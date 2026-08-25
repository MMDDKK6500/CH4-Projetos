### Arquivo: \⁠ ./Projetos/ViewModel/HomeViewModel.swift\ ⁠
⁠ swift
//
//  HomeViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//

import Foundation

import SwiftUI
import Observation

@Observable
class HomeViewModel {
    
    func checkProject(project: Project) -> ToggleSwitch {
        if (project.end! < Date()) {
            return .concluidos
        } else if (project.start! > Date()) {
            return .futuros
        } else {
            return .atuais
        }
    }
    
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/ViewModel/PostItViewModel.swift\ ⁠
⁠ swift
//
//  PostItViewModel.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI
import Observation

@Observable
class PostItViewModel {
    
    var task: Task
    
    public private(set) var subtitle: String

    init(task: Task) {
        self.task = task
    
        if Calendar.current.isDate(task.start!, inSameDayAs: task.end!) {
            
            if task.isAllDay {
                self.subtitle = "Hoje"
                return
            }
             
            self.subtitle = task.start!.formatted(.dateTime.month(.abbreviated).day())
            + " " +
            task.start!.formatted(.dateTime.hour().minute())
            + " - " +
            task.end!.formatted(.dateTime.hour().minute())
        } else if task.isAllDay {
            self.subtitle = task.start!.formatted(.dateTime.month(.abbreviated).day()) + " - " + task.end!.formatted(.dateTime.month(.abbreviated).day())
        } else {
            self.subtitle = task.start!.formatted(.dateTime.month(.abbreviated).day())
            + " " +
            task.start!.formatted(.dateTime.hour().minute())
            + " - " +
            task.end!.formatted(.dateTime.month(.abbreviated).day())
            + " " +
            task.end!.formatted(.dateTime.hour().minute())
        }
        
    }
    
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/ViewModel/CustomCalendarViewModel.swift\ ⁠
⁠ swift
//
//  CustomCalendarViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//

internal import CoreData
import Foundation
import Observation
import SwiftUI

@Observable
class CustomCalendarViewModel {

    let moc: NSManagedObjectContext

    let project: Project

    var selectedDate: Date = Date()

    let calendar = Calendar.current
    let daysOfWeek = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]

    var tasks: [Task] = []
    var notes: [Note] = []

    init(project: Project, context: NSManagedObjectContext) {
        self.moc = context
        self.project = project

        fetchProjectData()
    }

    private func fetchProjectData() {
        let taskRequest = Task.fetchRequest()
        taskRequest.predicate = NSPredicate(format: "project == %@", project)
        self.tasks = (try? moc.fetch(taskRequest)) as? [Task] ?? []

        let noteRequest = Note.fetchRequest()
        noteRequest.predicate = NSPredicate(format: "project == %@", project)
        self.notes = (try? moc.fetch(noteRequest)) as? [Note] ?? []
    }

    func selectDate(day: Int) {
        var components = calendar.dateComponents(
            [.year, .month, .day],
            from: selectedDate
        )
        components.day = day
        guard let updatedDate = calendar.date(from: components) else {
            return
        }
        selectedDate = updatedDate
    }

    func daysInMonth(date: Date) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }

    func dayBackgroundColor(for day: Int) -> Color {
        let isCurrentMonth = calendar.isDate(
            selectedDate,
            equalTo: Date(),
            toGranularity: .month
        )
        let isSelected = calendar.isDate(
            selectedDate,
            equalTo: date(withDay: day),
            toGranularity: .day
        )
        return isCurrentMonth && isSelected ? .blue : .clear
    }

    func dayForegroundColor(for day: Int) -> Color {

        let targetDate = date(withDay: day)

        let isToday = calendar.isDate(Date(), inSameDayAs: targetDate)
        let isCurrentMonth = calendar.isDate(
            selectedDate,
            equalTo: Date(),
            toGranularity: .month
        )
        let isSelected = calendar.isDate(selectedDate, inSameDayAs: targetDate)

        if isCurrentMonth && isSelected {
            return .white
        }

        if isToday && !isSelected && isCurrentMonth {
            return .blue
        }

        let dayHasTask = hasTask(on: day)
        let dayHasNote = hasNote(on: day)

        if dayHasTask && dayHasNote {
            return .purple
//        } else if dayHasTask {
//            return .green
        } else if dayHasNote {
            return .orange
        }

        // 4. Default: Standard text color for empty days
        return .primary
    }

    func date(withDay day: Int) -> Date {
        var components = calendar.dateComponents(
            [.year, .month, .day],
            from: selectedDate
        )
        components.day = day
        return calendar.date(from: components) ?? Date()
    }

    var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    func navigateToPreviousMonth() {
        guard
            let previousMonth = calendar.date(
                byAdding: .month,
                value: -1,
                to: selectedDate
            )
        else {
            return
        }
        selectedDate = previousMonth
    }

    func navigateToNextMonth() {
        guard
            let nextMonth = calendar.date(
                byAdding: .month,
                value: 1,
                to: selectedDate
            )
        else {
            return
        }
        selectedDate = nextMonth
    }

    // Source - https://stackoverflow.com/a/76494440
    // Posted by Sweeper
    // Retrieved 2026-08-13, License - CC BY-SA 4.0

    func numberOfLeadingSpacesInMonth(of date: Date) -> Int {
        guard
            let startOfMonth = calendar.dateComponents(
                [.calendar, .year, .month],
                from: date
            ).date
        else {
            return 0
        }
        let weekdayOfStartOfMonth = calendar.component(
            .weekday,
            from: startOfMonth
        )
        // a value of 1 means Sunday, so we subtract one
        return weekdayOfStartOfMonth - 1
    }

    func updateEndDate(to newDate: Date) {
        self.project.end = newDate

        do {
            try moc.save()
        } catch {
            print("Failed to save new end date: \(error)")
        }
    }

    func hasTask(on day: Int) -> Bool {
        let targetDate = date(withDay: day)

        return tasks.contains(where: { (task: Task) -> Bool in

            guard let taskDate = task.end else { return false }
            return calendar.isDate(taskDate, inSameDayAs: targetDate)
        })
    }

    func hasNote(on day: Int) -> Bool {
        let targetDate = date(withDay: day)

        return notes.contains(where: { (note: Note) -> Bool in

            guard let noteDate = note.date else { return false }
            return calendar.isDate(noteDate, inSameDayAs: targetDate)
        })
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/getBrightness.swift\ ⁠
⁠ swift
//
//  getBrightness.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//

// idk where to put this so it'll stay in the root ig

import Foundation
import UIKit

// https://gist.github.com/adamcichy/2d00c7a54009b4a9751ba513749c485e
func getBrightness(for image: UIImage) -> Int? {
    guard let cgImage = image.cgImage,
        let imageData = cgImage.dataProvider?.data,
        let dataPointer = CFDataGetBytePtr(imageData)
    else {
        return nil
    }
    let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
    let dataLength = CFDataGetLength(imageData)
    var result = 0.0
    for i in stride(from: 0, to: dataLength, by: bytesPerPixel) {
        let r = dataPointer[i]
        let g = dataPointer[i + 1]
        let b = dataPointer[i + 2]
        result += 0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b)
    }
    let pixelsCount = dataLength / bytesPerPixel
    let brightness = Int(result) / pixelsCount
    return brightness
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/NotificationManager.swift\ ⁠
⁠ swift
//
//  NotificationManager.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 21/08/26.
//
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleTaskNotification(taskId: UUID?, title: String, endDate: Date, option: NotificationOptions) {
        guard let taskId = taskId, option != .never else { return }

        let content = UNMutableNotificationContent()
        content.title = "⭐Lembre-se: \(title)"
        content.body = "Sua tarefa precisa da sua atenção!"
        content.sound = .default

        let calendar = Calendar.current

        switch option {
        case .never:
            return

        case .daily:
           
            let components = calendar.dateComponents([.hour, .minute], from: endDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            scheduleRequest(id: taskId.uuidString, content: content, trigger: trigger)

        case .weekDay:
            let timeComponents = calendar.dateComponents([.hour, .minute], from: endDate)
            for weekday in 2...6 {
                var components = timeComponents
                components.weekday = weekday
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                scheduleRequest(id: "\(taskId.uuidString)-weekday-\(weekday)", content: content, trigger: trigger)
            }

        case .weekend:
          
            let timeComponents = calendar.dateComponents([.hour, .minute], from: endDate)
            for weekday in [1, 7] {
                var components = timeComponents
                components.weekday = weekday
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                scheduleRequest(id: "\(taskId.uuidString)-weekend-\(weekday)", content: content, trigger: trigger)
            }

        case .fortnightly:
      
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 14 * 24 * 60 * 60, repeats: true)
            scheduleRequest(id: taskId.uuidString, content: content, trigger: trigger)

        case .monthly:
            let components = calendar.dateComponents([.day, .hour, .minute], from: endDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            scheduleRequest(id: taskId.uuidString, content: content, trigger: trigger)
        }
    }

    private func scheduleRequest(id: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotification(taskId: UUID?) {
        guard let taskId = taskId else { return }
      
        let identifiers = [taskId.uuidString] + (1...7).map { "\(taskId.uuidString)-weekday-\($0)" } + (1...7).map { "\(taskId.uuidString)-weekend-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/DataController.swift\ ⁠
⁠ swift
//
//  DataController.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import Foundation
internal import CoreData
import Combine

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Projects")
    
    init() {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/Project+CoreDataProperties.swift\ ⁠
⁠ swift
//
//  Project+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData


public typealias ProjectCoreDataPropertiesSet = NSSet

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var color: Int64
    @NSManaged public var descriptionText: String?
    @NSManaged public var end: Date?
    @NSManaged public var favorite: Bool
    @NSManaged public var id_project: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var start: Date?

}

extension Project : Identifiable {
    func getColorPalette() -> CoreDataColor {
        return CoreDataColor(rawValue: Int(color))!
    }
    
    func getDescriptionText() -> String {
        return descriptionText ?? ""
    }
    
    func getName() -> String {
        return name ?? ""
    }
    
    func getId() -> UUID {
        return id_project ?? UUID()
    }
    
    func getImage() -> Data {
        return image ?? Data()
    }
    
    func getStart() -> Date {
        return start ?? Date()
    }
    
    func getEnd() -> Date {
        return end ?? Date()
    }
    
    func getFavorite() -> Bool {
        return favorite
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/Task+CoreDataProperties.swift\ ⁠
⁠ swift
//
//  Task+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData


public typealias TaskCoreDataPropertiesSet = NSSet

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var color: Int64
    @NSManaged public var end: Date?
    @NSManaged public var id_task: UUID?
    @NSManaged public var isAllDay: Bool
    @NSManaged public var start: Date?
    @NSManaged public var status: Int64
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var project: Project?

}

extension Task : Identifiable {
    func getColorPalette() -> CoreDataColor {
        return CoreDataColor(rawValue: Int(color))!
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/AttatchmentNote+CoreDataClass.swift\ ⁠
⁠ swift
//
//  AttatchmentNote+CoreDataClass.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData

public typealias AttatchmentNoteCoreDataClassSet = NSSet

@objc(AttatchmentNote)
public class AttatchmentNote: NSManagedObject {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/AttatchmentNote+CoreDataProperties.swift\ ⁠
⁠ swift
//
//  AttatchmentNote+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData


public typealias AttatchmentNoteCoreDataPropertiesSet = NSSet

extension AttatchmentNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttatchmentNote> {
        return NSFetchRequest<AttatchmentNote>(entityName: "AttatchmentNote")
    }

    @NSManaged public var id_attatchment: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var note: Note?

}

extension AttatchmentNote : Identifiable {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/Project+CoreDataClass.swift\ ⁠
⁠ swift
//
//  Project+CoreDataClass.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData

public typealias ProjectCoreDataClassSet = NSSet

@objc(Project)
public class Project: NSManagedObject {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/Note+CoreDataProperties.swift\ ⁠
⁠ swift
//
//  Note+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData


public typealias NoteCoreDataPropertiesSet = NSSet

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id_note: UUID?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var project: Project?

}

extension Note : Identifiable {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/User+CoreDataProperties.swift\ ⁠
⁠ swift
//
//  User+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData


public typealias UserCoreDataPropertiesSet = NSSet

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var onboarding: Bool

}

extension User : Identifiable {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/Task+CoreDataClass.swift\ ⁠
⁠ swift
//
//  Task+CoreDataClass.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData

public typealias TaskCoreDataClassSet = NSSet

@objc(Task)
public class Task: NSManagedObject {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/User+CoreDataClass.swift\ ⁠
⁠ swift
//
//  User+CoreDataClass.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData

public typealias UserCoreDataClassSet = NSSet

@objc(User)
public class User: NSManagedObject {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/Models/Note+CoreDataClass.swift\ ⁠
⁠ swift
//
//  Note+CoreDataClass.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData

public typealias NoteCoreDataClassSet = NSSet

@objc(Note)
public class Note: NSManagedObject {

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/CoreData/CoreDataColor.swift\ ⁠
⁠ swift
//
//  CoreDataColor.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 17/08/26.
//

import Foundation
import SwiftUI

// https://www.reddit.com/r/SwiftUI/s/us0lIR880C
// https://www.reddit.com/r/SwiftUI/comments/hjnd8k/use_a_string_from_coredata_to_set_a_color
// https://www.reddit.com/r/SwiftUI/comments/hjnd8k/comment/fwnnjhl

enum CoreDataColor: Int, CaseIterable {
    case blue, cyan, green, pink, purple, yellow

    var background: Color {
        switch self {
        case .blue: return Color.Blue.background
        case .cyan: return Color.Cyan.background
        case .green: return Color.Green.background
        case .pink: return Color.Pink.background
        case .purple: return Color.Purple.background
        case .yellow: return Color.Yellow.background
        }
    }

    var title: Color {
        switch self {
        case .blue: return Color.Blue.title
        case .cyan: return Color.Cyan.title
        case .green: return Color.Green.title
        case .pink: return Color.Pink.title
        case .purple: return Color.Purple.title
        case .yellow: return Color.Yellow.title
        }
    }

    var subtitle: Color {
        switch self {
        case .blue: return Color.Blue.subtitle
        case .cyan: return Color.Cyan.subtitle
        case .green: return Color.Green.subtitle
        case .pink: return Color.Pink.subtitle
        case .purple: return Color.Purple.subtitle
        case .yellow: return Color.Yellow.subtitle
        }
    }
    
    var tag: Color {
        switch self {
        case .blue: return Color.Blue.tag
        case .cyan: return Color.Cyan.tag
        case .green: return Color.Green.tag
        case .pink: return Color.Pink.tag
        case .purple: return Color.Purple.tag
        case .yellow: return Color.Yellow.tag
        }
    }

    var name: String {
        switch self {
        case .blue: return "Blue"
        case .cyan: return "Cyan"
        case .green: return "Green"
        case .pink: return "Pink"
        case .purple: return "Purple"
        case .yellow: return "Yellow"
        }
    }

    var nome: String {
        switch self {
        case .blue: return "Azul"
        case .cyan: return "Ciano"
        case .green: return "Verde"
        case .pink: return "Rosa"
        case .purple: return "Roxo"
        case .yellow: return "Amarelo"
        }
    }

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/Extensions/BindingExtension.swift\ ⁠
⁠ swift
//
//  BindingExtension.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//

import Foundation
import SwiftUI

extension Binding where Value: Equatable {
    func equals(_ other: Value, else unset: Value) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue == other },
            set: { self.wrappedValue = $0 ? other : unset }
        )
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/Extensions/UIImageExtension.swift\ ⁠
⁠ swift
//
//  UIImageExtension.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 20/08/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        let filter = CIFilter.areaAverage()
        filter.inputImage = inputImage
        filter.extent = inputImage.extent // Use CGRect directly
        
        let context = CIContext()
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4) // RGBA format
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1), // 1x1 pixel
            format: .RGBA8,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )
        
        return UIColor(
            red: CGFloat(bitmap[0]) / 255.0,
            green: CGFloat(bitmap[1]) / 255.0,
            blue: CGFloat(bitmap[2]) / 255.0,
            alpha: CGFloat(bitmap[3]) / 255.0
        )
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/Model/NotificationOptions.swift\ ⁠
⁠ swift
//
//  NotificationOptions.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 21/08/26.
//

enum NotificationOptions: Int, CaseIterable {
    case never
    case daily
    case weekDay
    case weekend
    case fortnightly
    case monthly

    var toString : String {
        switch self {
        case .never:
            return "Nunca"
        case .daily:
            return "Diariamente"
        case .weekDay:
            return "Dias de Semana"
        case .weekend:
            return "Finais de Semana"
        case .fortnightly:
            return "Quinzenalmente"
        case .monthly:
            return "Mensalmente"
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/Model/ToggleSwitch.swift\ ⁠
⁠ swift
//
//  ToggleSwitch.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//

enum ToggleSwitch: Equatable {
    case concluidos, atuais, futuros
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/Model/TaskStatus.swift\ ⁠
⁠ swift
//
//  TaskStatus.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

enum TaskStatus: Int, CaseIterable {
    case toDo
    case inProgress
    case completed
    
    var toString : String {
        switch self {
            case .toDo:
            return "A Fazer"
        case .inProgress:
            return "Em Andamento"
        case .completed:
            return "Concluído"
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/Model/ZipNavigationEnum.swift\ ⁠
⁠ swift
//
//  ZipNavigationEnum.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 20/08/26.
//
import Foundation

enum ZipNavigationEnum: Hashable, Identifiable {
                                              
                                               
    var id: Self { self }
  //  case splashscreen
    case welcomeView
    case onBoarding
    case homeView
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Sheets/NewTask.swift\ ⁠
⁠ swift
//
//  SheetNewTask.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI
internal import CoreData

struct NewTask: View {
    
    @State var titleTask: String = ""
    @State var descriptionTask: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var toggleAllDay: Bool = false
    @State var colorValue: Int = 0
    
    var textLengh: Int = 128
    
    @State var selectionStatus: TaskStatus = .toDo
    @State var selectionNotification: NotificationOptions = .never
    
    @State var createError: Bool = false
    
    let project: Project
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section (header: Text("Título da Tarefa")){
                TextField("Título", text: $titleTask)
            }
            
            Section (header: Text("Descrição da Tarefa")){
                TextField("Fale brevemente sobre sua tarefa.", text: $descriptionTask, axis: .vertical)
                    .lineLimit(6...6)
                    .onChange(of: descriptionTask, {
                        descriptionTask = String(descriptionTask.prefix(textLengh))
                    })
                    
            }
            Section (header: Text("Lembrete")) {
                HStack {
                    Text("Dia Inteiro")
                    Spacer()
                    Toggle(isOn: $toggleAllDay) {}
                        .tint(Color.lightBlue)
                }
                HStack {
                    Text("Começa")
                    Spacer()
                    DatePicker("", selection: $startDate, displayedComponents: toggleAllDay ? [.date] : [.date, .hourAndMinute])
                }
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
                
                HStack {
                    Text("Termina")
                    Spacer()
                    DatePicker("", selection: $endDate, displayedComponents: toggleAllDay ? [.date] : [.date, .hourAndMinute])
                }
                
                Picker("Notificação", selection: $selectionNotification) {
                    ForEach (NotificationOptions.allCases, id: \.self) { option in
                        Text(option.toString)
                    }
                }
                
                
            }
            
            Section (header: Text("Personalização")) {
                HStack {
                    Text("Cor da Tarefa")
                    Spacer()
                    ColorPickerView(colorValue: $colorValue)
                }
                Picker("Status da Tarefa", selection: $selectionStatus) {
                    ForEach (TaskStatus.allCases, id: \.self) { option in
                        Text(option.toString)
                    }
                }
            }
        }
        
        .alert("Error", isPresented: $createError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("", systemImage: "xmark", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "checkmark", role: .confirm) {
                    
                    if (titleTask.isEmpty || descriptionTask.isEmpty) {
                        createError.toggle()
                    } else {
                        
                        let taskId = UUID()

                        let task = Task(context: moc)
                        task.title = titleTask
                        task.text = descriptionTask
                        task.color = Int64(colorValue)
                        task.start = startDate
                        task.isAllDay = toggleAllDay
                        task.end = endDate
                        task.project = project
                        task.id_task = taskId
                        task.status = Int64(selectionStatus.rawValue)

                        do {
                            try moc.save()
                            
                            NotificationManager.shared.scheduleTaskNotification(
                                taskId: taskId,
                                title: titleTask,
                                endDate: endDate,
                                option: selectionNotification
                            )
                        } catch {
                            fatalError("Error saving context \(error)")
                        }

                        dismiss()
                    }
                }
            }
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Sheets/NewNote.swift\ ⁠
⁠ swift
//
//  NewNote.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI
internal import CoreData

struct NewNote: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var titleNote: String = ""
    @State private var descriptionNote: String = ""
    
    @State private var createError: Bool = false
    
    let project: Project
    
    var body: some View {
        Form {
            Section (header: Text("Título da Anotação")){
                TextField("Título", text: $titleNote)
            }
            
            Section (header: Text("Descrição da Anotação")){
                TextField("Digite aqui o conteúdo da sua anotação.", text: $descriptionNote, axis: .vertical)
                    .lineLimit(10...10)
                
            }
        }
        
        .alert("Error", isPresented: $createError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("", systemImage: "xmark", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "checkmark", role: .confirm) {
                    
                    if (titleNote.isEmpty || descriptionNote.isEmpty) {
                        createError.toggle()
                    } else {
                        
                        let note = Note(context: moc)
                        
                        note.id_note = UUID()
                        note.date = Date()
                        note.title = titleNote
                        note.text = descriptionNote
                        note.project = project
                        
                        do {
                            try moc.save()
                        } catch {
                            fatalError("Error saving context \(error)")
                        }
                        
                        dismiss()
                    }
                }
            }
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Sheets/SheetCreation.swift\ ⁠
⁠ swift
//
//  SheetCreation.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct SheetCreation: View {

    @State private var segmented = 0

    let project: Project

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                Picker("", selection: $segmented) {
                    Text("Tarefa").tag(0)
                    Text("Anotação").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if segmented == 0 {
                    NewTask(project: project)
                } else {
                    NewNote(project: project)
                }
            }
        }
        .background(
            Color("geralBackground")
        )
        .navigationTitle(segmented == 0 ? "Nova Tarefa" : "Nova Anotação")
        .navigationBarTitleDisplayMode(.inline)
        .presentationDragIndicator(.visible)
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Sheets/SheetNewProject.swift\ ⁠
⁠ swift
//
//  SheetNewProject.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI
internal import CoreData
import PhotosUI

struct SheetNewProject: View {
    
    @State private var titleProject: String = ""
    @State private var descriptionProject: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isFavorite: Bool = false
    
    @State private var color: Int = 0
    
    @State var image: Image?
    
    @State var imageData: Data?
    
    @State var photoSelection: PhotosPickerItem?
    
    let project: Project?
    
    @State private var createError: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    
    init(project: Project? = nil) {
        self.project = project
        
        if let project {
            _titleProject = State(initialValue: project.getName())
            _descriptionProject = State(initialValue: project.getDescriptionText())
            _startDate = State(initialValue: project.getStart())
            _endDate = State(initialValue: project.getEnd())
            _isFavorite = State(initialValue: project.getFavorite())
            _color = State(initialValue: Int(project.color))
            
            if let data = project.image, let uiImage = UIImage(data: data) {
                _imageData = State(initialValue: data)
                _image = State(initialValue: Image(uiImage: uiImage))
            } else {
                _imageData = State(initialValue: nil)
                _image = State(initialValue: nil)
            }
            
        } else {
            _titleProject = State(initialValue: "")
            _descriptionProject = State(initialValue: "")
            _startDate = State(initialValue: Date())
            _endDate = State(initialValue: Date())
            _isFavorite = State(initialValue: false)
            _color = State(initialValue: 0)
            
            _imageData = State(initialValue: nil)
            _image = State(initialValue: nil)
        }
        
        _createError = State(initialValue: false)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                HStack{
                    Spacer()
                    PhotosPicker(selection: $photoSelection, matching: .images) {
                        Group {
                            if let image {
                                 image
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: 200, height: 200)
                                     .clipShape(
                                        RoundedRectangle(cornerRadius: 26)
                                     )
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.title.bold())
                                    .foregroundStyle(Color.lightBlue)
                                    .frame(width: 200, height: 200)
                                    .background (
                                        RoundedRectangle(cornerRadius: 26)
                                            .fill(Color(.secondarySystemBackground))
                                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
                                    )
                            }
                        }
                    }
                    // https://stackoverflow.com/questions/79331226/how-to-use-a-photo-picker-and-display-the-selected-photo-within-a-single-sheet-i
                    .onChange(of: photoSelection) { oldValue, newValue in
                        guard let newValue else { return }
                        changeImage(to: newValue)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                Section (header: Text("Título do Projeto")){
                    TextField("Título", text: $titleProject)
                }
                
                Section (header: Text("Descrição do Projeto")){
                    TextField("Digite aqui a descrição do seu projeto.", text: $descriptionProject, axis: .vertical)
                        .lineLimit(6...6)
                }
                
                Section (header: Text("Lembrete")){
                    HStack {
                        Text("Favoritar")
                        Spacer()
                        Favorite(isFavorite: $isFavorite)
                    }
                    if (image == nil) {
                        HStack {
                            Text("Cor")
                            Spacer()
                            ColorPickerView(colorValue: $color)
                        }
                    }
                     HStack {
                        Text("Começa")
                        DatePicker("", selection: $startDate)
                            .onChange(of: startDate) {
                                if (endDate < startDate) {
                                    endDate = startDate
                                }
                            }
                    }
                    HStack {
                        Text("Termina")
                        DatePicker("", selection: $endDate)
                    }
                }
                
            }
            .navigationTitle("Novo Projeto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("", systemImage: "xmark", role: .cancel) {
                        
                        dismiss()
                        
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("", systemImage: "checkmark", role: .confirm) {
                        
                        if (titleProject.isEmpty || descriptionProject.isEmpty) {
                            createError.toggle()
                        } else {
                            
                            let projeto = project ?? Project(context: moc)
                            
                            projeto.name = titleProject
                            projeto.descriptionText = descriptionProject
                            projeto.id_project = project == nil ? UUID() : projeto.id_project
                            projeto.favorite = isFavorite
                            projeto.start = startDate
                            projeto.color = Int64(color)
                            if (image == nil) {
                                projeto.image = nil
                            } else {
                                projeto.image = imageData
                            }
                            projeto.end = endDate
                            
                            do {
                                try moc.save()
                            } catch {
                                fatalError("Error saving context \(error)")
                            }
                            
                            dismiss()
                        }
                    }
                }
            }
            .presentationDragIndicator(.visible)
            .alert("Error", isPresented: $createError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Por favor preencher todos os campos no formulário")
            }
        }
    }
    
    func changeImage(to pickerItem: PhotosPickerItem) {
        Swift.Task {
            do {
                self.imageData = try await pickerItem.loadTransferable(type: Data.self)
                
                guard let inputImage = UIImage(data: imageData!) else { return }
                
                self.image = Image(uiImage: inputImage)
            } catch {
                print("Error converting image to ")
            }
        }
    }
}

#Preview {
    SheetNewProject()
        .sheet(isPresented: .constant(true)) {
            SheetNewProject()
        }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Sheets/SheetOnBoarding.swift\ ⁠
⁠ swift
//
//  SheetOnBoarding.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct SheetOnBoarding: View {
@Environment(\.dismiss) private var dismiss
var onComplete: () -> Void = {}
    
var body: some View {
    NavigationStack {
        ZStack {
            Color("geralBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 60) {
                Spacer()
                
                Text("Descubra tudo que o Zip oferece")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                
                //Spacer()
                TextOnBoarding(text: "Organize seus prazos e encontros. Visualize as datas importantes do projeto e saiba o que vem pela frente.", icon: "calendar")
                TextOnBoarding(text: "Não deixe nenhuma tarefa para trás. Crie lembretes para acompanhar o que precisa ser feito e quando.", icon: "checklist")
                TextOnBoarding(text: "Registre suas ideias e informações. Anote detalhes, referências e tudo o que for importante para o projeto.", icon: "pencil.line")
                
                Spacer()
                
                Button {
                    onComplete()
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Text("Continuar")
                            .font(.body.weight(.bold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(Color.accent)
                    .cornerRadius(30)
                }
                .padding(.horizontal, 10)
                
            }
            .padding(18)
        }
        .navigationBarTitleDisplayMode(.inline)
        .presentationDragIndicator(.visible)
        
        }
    }
}

#Preview {
    SheetOnBoarding()
        .sheet(isPresented: .constant(true)) {
            SheetOnBoarding()
        }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/NoteView.swift\ ⁠
⁠ swift
//
//  NoteScreen.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 19/08/26.
//

internal import CoreData
import SwiftUI

struct NoteView: View {

    @Environment(\.managedObjectContext) private var moc

    let note: Note

    @State var noteTitle: String
    @State var noteText: String
    @State var editError: Bool = false

    init(note: Note) {
        self.note = note
        _noteTitle = State(initialValue: note.title!)
        _noteText = State(initialValue: note.text!)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField("Título da anotação", text: $noteTitle)
                .font(.title.bold())

            Text(note.date!.formatted(date: .numeric, time: .shortened))
                .font(.body)
                .foregroundStyle(Color.secondary)

            Spacer()

            TextEditor(text: $noteText)
                .ignoresSafeArea()
                .scrollContentBackground(.hidden)

            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(.systemGroupedBackground))

        .onChange(of: [noteText, noteTitle]) {
            if noteTitle.isEmpty || noteText.isEmpty {
                noteTitle.isEmpty ? (noteTitle = note.date!.formatted()) : ()
                noteText.isEmpty ? (noteText = note.date!.formatted()) : ()

                editError.toggle()
            } else {

                //                note.id_note = UUID()
                //                note.date = Date()
                note.title = noteTitle
                note.text = noteText
                //                note.project = project

                do {
                    try moc.save()
                } catch {
                    fatalError("Error saving context \(error)")
                }
            }
        }

        .alert("Error", isPresented: $editError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }

        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                //                Button(action: {}) {
                //                    Image(systemName: "square.and.arrow.up")
                //                }
                ShareLink(
                    item: noteText,
                    label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                )
                .tint(.blue)

                //                Menu {

                // How to do this?
                //                    Button(action: {}) {
                //                        Label("Pesquisar", systemImage: "magnifyingglass")
                //                    }

                //   Button (action: {}) {
                //       Label("Mudar modo de visualização", systemImage: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                //  }

                Button(role: .destructive, action: {}) {
                    Label("Excluir nota", systemImage: "trash")
                }
                .tint(.red)

                //                } label: {
                //                    Image(systemName: "ellipsis")
                //                }

            }

            // If can make rich text work uncomment
            //            ToolbarItemGroup(placement: .keyboard) {
            //                HStack(spacing: 20) {
            //                    Spacer()
            //                    HStack(spacing: 18) {
            //                        Button(action: {}) { Image(systemName: "paperclip") }
            //                        Button(action: {}) {
            //                            Image(systemName: "textformat.alt")
            //                        }
            //                        Button(action: {}) {
            //                            Image(systemName: "bold")
            //                        }
            //                        Button(action: {}) {
            //                            Image(systemName: "italic")
            //                        }
            //                    }
            //                    .font(.title3)
            //                    .foregroundStyle(
            //                        .primary
            //                    )
            //                }
            //            }
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/ZipNavigation.swift\ ⁠
⁠ swift
//
//  ZipNavigation.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 20/08/26.
//

import SwiftUI

struct ZipNavigation {
    @ViewBuilder static func viewShowed(rote: ZipNavigationEnum) -> some View {
        switch rote {
            //     case .splash:
            //         TelaSplash(aoTerminar: {})
            
        case .welcomeView:
            WelcomeView()
            
        case .onBoarding:
            SheetOnBoarding()
            
        case .homeView:
            HomeView()
            
        }
     }
 }
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/HomeView.swift\ ⁠
⁠ swift
//
//  HomeView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//
internal import CoreData
import SwiftUI

struct HomeView: View {

    @State var vm = HomeViewModel()
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: [])
    var projects: FetchedResults<Project>

    @State var showFutureProjects: Bool = true
    @State var showCurrentProjects: Bool = false
    @State var showOldProjects: Bool = false
    
    @State private var selectedOption: ToggleSwitch = .atuais
    @State var newProject = false

    var body: some View {
        Group {
            if projects.isEmpty {
                ContentUnavailableView {
                    Text("Você ainda não possui nenhum projeto")
                        .font(Font.title2.bold())
                } description: {
                    Text("Seus projetos criados aparecerão aqui")
                        .font(Font.body)
                }
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(projects.filter { $0.favorite == true && vm.checkProject(project: $0) == selectedOption}) { project in
                            NavigationLink {
                                ProjectView(project: project)
                            } label: {
                                ProjectComponentView(project: project)
                                    .background {
                                        if project.image == nil {
                                            project.getColorPalette().background
                                        } else {
                                            Image(uiImage: UIImage(data: project.image!)!)
                                                .resizable()
                                                .scaledToFill()
                                        }
                                    }
                                    .clipShape(.rect(cornerRadius: 26))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        LazyVGrid(
                            columns: [GridItem(), GridItem()],
                            alignment: .center,
                            spacing: 10
                        ) {
                            ForEach(projects.filter { $0.favorite == false && vm.checkProject(project: $0) == selectedOption }) { project in
                                NavigationLink {
                                    ProjectView(project: project)
                                } label: {
                                    ProjectComponentView(project: project)
                                }
                                .buttonStyle(.plain)
                                .background {
                                    if project.image == nil {
                                        project.getColorPalette().background
                                    } else {
                                        Image(uiImage: UIImage(data: project.image!)!)
                                            .resizable()
                                            .scaledToFill()
                                    }
                                }
                                .clipShape(.rect(cornerRadius: 26))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    newProject.toggle()
                }
                Menu {
                    Toggle("Projetos concluidos", isOn: $selectedOption.equals(.concluidos, else: .concluidos))
                    Toggle("Projetos atuais", isOn: $selectedOption.equals(.atuais, else: .atuais))
                    Toggle("Projetos futuros", isOn: $selectedOption.equals(.futuros, else: .futuros))
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
            }
        }
        .navigationDestination(for: Project.self) { project in
            ProjectView(project: project)
        }
        .navigationTitle("Meus Projetos")
        .toolbarTitleDisplayMode(.inlineLarge)
        .sheet(isPresented: $newProject) {
            SheetNewProject()
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Shapes/CutCornerRectangle.swift\ ⁠
⁠ swift
//
//  TextView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import SwiftUI

struct CutCornerRectangle: Shape {

    var cornerRadius: CGFloat = 26
//    var foldSize: CGFloat = 48

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // top-left
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        
        // right top
        path.addLine(to: CGPoint(x: rect.maxX - rect.width / 5, y: rect.minY))
        
        // right mid
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.width / 5))
        
        // right bottom
        path.addArc(
            center: CGPoint(
                x: rect.maxX - cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        
        // bottom
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )

        path.closeSubpath()
        return path
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Shapes/TaskFlap.swift\ ⁠
⁠ swift
//
//  TakFlap.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import Foundation
import SwiftUI

struct TaskFlap: Shape {

//    var cornerRadius: CGFloat = 26

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start at top-left of the flap
        path.move(to: CGPoint(x: rect.maxX - rect.width / 5, y: rect.minY))

        path.addLine(to: CGPoint(x: rect.maxX - rect.width / 5, y: rect.minY + rect.width / 5 / 2))
        
//        path.addLine(to: CGPoint(x: rect.maxX - rect.width / 5 / 2, y: rect.minY + rect.width / 5))
        
        path.addCurve(
            to: CGPoint(x: rect.maxX - rect.width / 5 / 2, y: rect.minY + rect.width / 5),
            control1: CGPoint(x: rect.maxX - rect.width / 5, y: rect.minY + rect.width / 5 / 2),
            control2: CGPoint(x: rect.maxX - rect.width / 5, y: rect.minY + rect.width / 5)
        )
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.width / 5))
        
//        path.addArc(
//            tangent1End: CGPoint(
//                x: rect.maxX - rect.width / 5,
//                y: rect.minY + rect.width / 5
//            ),
//            tangent2End: CGPoint(x: rect.maxX, y: rect.minY + rect.width / 5),
//            radius: cornerRadius
//

        path.closeSubpath()
        return path
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/WelcomeView.swift\ ⁠
⁠ swift
//
//  WelcomeView.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showOnboarding: Bool = false
    
   
    var body: some View {
        ZStack {
            Color("geralBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 45) {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(24)
                
                Text("Bem-Vindo ao Zip")
                    .font(.largeTitle.bold())
                
                Spacer()
                Text("Uma nova forma de organizar seus projetos, tarefas e ideias em um único espaço.")
                    .font(.body)
                Text("Planeje cada etapa, acompanhe o andamento das atividades e mantenha todas as informações importantes do seu projeto reunidas e organizadas no Zip.")
                    .font(.body)
                
                Spacer()
                
                Button {
                    showOnboarding.toggle()
                } label: {
                    HStack(spacing: 8) {
                        Text("Continuar")
                            .font(.body.weight(.bold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(Color.accent)
                    .cornerRadius(30)
                }
                
            }
            .padding(20)
        }
        .sheet(isPresented: $showOnboarding) {
            SheetOnBoarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Components/VariableBlur.swift\ ⁠
⁠ swift

//https://github.com/nikstar/VariableBlur/blob/main/LICENSE.md

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins
import QuartzCore


public enum VariableBlurDirection {
    case blurredTopClearBottom
    case blurredBottomClearTop
}


public struct VariableBlurView: UIViewRepresentable {
    
    public var maxBlurRadius: CGFloat = 20
    
    public var direction: VariableBlurDirection = .blurredTopClearBottom
    
    /// By default, variable blur starts from 0 blur radius and linearly increases to `maxBlurRadius`. Setting `startOffset` to a small negative coefficient (e.g. -0.1) will start blur from larger radius value which might look better in some cases.
    public var startOffset: CGFloat = 0
    
    public init(maxBlurRadius: CGFloat = 20, direction: VariableBlurDirection = .blurredTopClearBottom, startOffset: CGFloat = 0) {
        self.maxBlurRadius = maxBlurRadius
        self.direction = direction
        self.startOffset = startOffset
    }
    
    public func makeUIView(context: Context) -> VariableBlurUIView {
        VariableBlurUIView(maxBlurRadius: maxBlurRadius, direction: direction, startOffset: startOffset)
    }

    public func updateUIView(_ uiView: VariableBlurUIView, context: Context) {
    }
}


/// credit https://github.com/jtrivedi/VariableBlurView
open class VariableBlurUIView: UIVisualEffectView {

    public init(maxBlurRadius: CGFloat = 20, direction: VariableBlurDirection = .blurredTopClearBottom, startOffset: CGFloat = 0) {
        super.init(effect: UIBlurEffect(style: .regular))

        let clsName = String("retliFAC".reversed())
        guard let Cls = NSClassFromString(clsName)! as? NSObject.Type else {
            print("[VariableBlur] Error: Can't find filter class")
            return
        }
        let selName = String(":epyThtiWretlif".reversed())
        guard let variableBlur = Cls.self.perform(NSSelectorFromString(selName), with: "variableBlur").takeUnretainedValue() as? NSObject else {
            print("[VariableBlur] Error: Can't create variableBlur filter")
            return
        }

        // The blur radius at each pixel depends on the alpha value of the corresponding pixel in the gradient mask.
        // An alpha of 1 results in the max blur radius, while an alpha of 0 is completely unblurred.
        let gradientImage = makeGradientImage(startOffset: startOffset, direction: direction)

        variableBlur.setValue(maxBlurRadius, forKey: "inputRadius")
        variableBlur.setValue(gradientImage, forKey: "inputMaskImage")
        variableBlur.setValue(true, forKey: "inputNormalizeEdges")

        // We use a `UIVisualEffectView` here purely to get access to its `CABackdropLayer`,
        // which is able to apply various, real-time CAFilters onto the views underneath.
        let backdropLayer = subviews.first?.layer

        // Replace the standard filters (i.e. `gaussianBlur`, `colorSaturate`, etc.) with only the variableBlur.
        backdropLayer?.filters = [variableBlur]
        
        // Get rid of the visual effect view's dimming/tint view, so we don't see a hard line.
        for subview in subviews.dropFirst() {
            subview.alpha = 0
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func didMoveToWindow() {
        // fixes visible pixelization at unblurred edge (https://github.com/nikstar/VariableBlur/issues/1)
        guard let window, let backdropLayer = subviews.first?.layer else { return }
        backdropLayer.setValue(window.traitCollection.displayScale, forKey: "scale")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // `super.traitCollectionDidChange(previousTraitCollection)` crashes the app
    }
    
    private func makeGradientImage(width: CGFloat = 100, height: CGFloat = 100, startOffset: CGFloat, direction: VariableBlurDirection) -> CGImage { // much lower resolution might be acceptable
        let ciGradientFilter =  CIFilter.linearGradient()
//        let ciGradientFilter =  CIFilter.smoothLinearGradient()
        ciGradientFilter.color0 = CIColor.black
        ciGradientFilter.color1 = CIColor.clear
        ciGradientFilter.point0 = CGPoint(x: 0, y: height)
        ciGradientFilter.point1 = CGPoint(x: 0, y: startOffset * height) // small negative value looks better with vertical lines
        if case .blurredBottomClearTop = direction {
            ciGradientFilter.point0.y = 0
            ciGradientFilter.point1.y = height - ciGradientFilter.point1.y
        }
        return CIContext().createCGImage(ciGradientFilter.outputImage!, from: CGRect(x: 0, y: 0, width: width, height: height))!
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Components/ColorPickerView.swift\ ⁠
⁠ swift
//
//  ColorPickerView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 17/08/26.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var colorValue: Int
    
    var body: some View {
        HStack {
            Spacer()
            Menu {
                ForEach(CoreDataColor.allCases, id: \.self) { color in
                    Button(action: {
                        colorValue = color.rawValue
                    }) {
                        Label(CoreDataColor(rawValue: color.rawValue)!.name, systemImage: "circle.fill")
                        //https://stackoverflow.com/questions/75856718/swiftui-how-to-color-a-menu-button-icon-in-macos
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                CoreDataColor(rawValue: color.rawValue)!.background
                            )
                    }
                }
            } label: {
                Circle()
                    .frame(maxWidth: 44, maxHeight: 44)
                    .foregroundStyle(CoreDataColor(rawValue: colorValue)!.background)
                    .glassEffect()
            }
        }
    }
}

#Preview {
    @Previewable @State var colorValue = 0
    
    List {
        ColorPickerView(colorValue: $colorValue)
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Components/CustomCalendarView.swift\ ⁠
⁠ swift
//
//  CustomCalendarView.swift
//
//  Source - https://stackoverflow.com/q/76493800
//  Posted by kitchen800
//  Retrieved 2026-08-13, License - CC BY-SA 4.0
//
//  Edited by João Duque Nardelli Wandermuren
//

internal import CoreData
import SwiftUI

struct CustomCalendarView: View {

    @Environment(\.managedObjectContext) var moc

    let daySelect: (_ selectedDate: Date) -> Void

    let projeto: Project

    @State var vm: CustomCalendarViewModel

    @State var startDate: Date
    @State var endDate: Date

    init(
        daySelect: @escaping (_ selectedDate: Date) -> Void,
        projeto: Project,
        moc: NSManagedObjectContext
    ) {

        self.daySelect = daySelect
        self.projeto = projeto

        _vm = State(
            initialValue: CustomCalendarViewModel(
                project: projeto,
                context: moc
            )
        )
        _startDate = State(initialValue: projeto.getStart())
        _endDate = State(initialValue: projeto.getEnd())
    }

    var body: some View {
        VStack {
            HStack {
                Text(vm.monthYearFormatter.string(from: vm.selectedDate))
                    .font(.headline)
                //.padding(.bottom, 10)

                // TODO: Month/Year Select

                Spacer()

                Button(action: {
                    vm.navigateToPreviousMonth()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                }
                .padding(.trailing, 8)

                Button(action: {
                    vm.navigateToNextMonth()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                }
                .padding(.leading, 8)
            }
            .padding(.bottom, 20)

            HStack {
                ForEach(vm.daysOfWeek, id: \.self) { day in
                    Text(day.uppercased())
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                // Source - https://stackoverflow.com/a/76494440
                // Posted by Sweeper
                // Retrieved 2026-08-13, License - CC BY-SA 4.0

                ForEach(
                    0..<vm.numberOfLeadingSpacesInMonth(of: vm.selectedDate),
                    id: \.self
                ) { i in
                    Spacer().id("Spacer \(i)")
                }

                ForEach(1...vm.daysInMonth(date: vm.selectedDate), id: \.self) {
                    day in
                    Text("\(day)")
                        .font(.headline)
                        .fontWeight(.medium)
                        .frame(minWidth: 44, minHeight: 44)
                        //                        .frame(maxWidth: .infinity)
                        .background(vm.dayBackgroundColor(for: day))
                        .foregroundColor(vm.dayForegroundColor(for: day))
                        .clipShape(
                            .circle
                        )
                        //                        .padding(5)

                        .onTapGesture {
                            daySelect(vm.date(withDay: day))
                            vm.selectDate(day: day)
                        }
                }
            }

            Divider()

            DatePicker(
                selection: $endDate,
                label: {
                    Text("Prazo Final")
                }
            )
            .onChange(of: endDate) {
                projeto.end = endDate
                vm.updateEndDate(to: endDate)
            }
            .padding(.top, 8)
        }
        .padding()
    }

}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Components/ProjectComponentView.swift\ ⁠
⁠ swift
//
//  ProjectComponentView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import SwiftUI

struct ProjectComponentView: View {

    @ObservedObject var project: Project

    let uiImage: UIImage?

    var brightness: Int = 0

    init(project: Project) {
        self.project = project
        if (project.image == nil) {
            uiImage = nil
        } else {
            uiImage = UIImage(data: project.image!)!
            brightness = getBrightness(for: uiImage!)!
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("Prazo Final")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(project.getEnd().formatted(.dateTime.day()))
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                    Text(project.getEnd().formatted(.dateTime.month().year()))
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                Text(project.getName())
                    .lineLimit(2)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .foregroundStyle(
            uiImage == nil ? .black : Color(brightness > 128 ? .black : .white)
        )
        .padding()
        .contentShape(Rectangle())
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 26))
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Components/PostIt.swift\ ⁠
⁠ swift
import SwiftUI
import Observation
internal import CoreData

struct PostIt: View {

    @State var viewModel: PostItViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var task: Task
    
    let cornerRadius: CGFloat = 26
    
    private func updateTaskStatus(to newStatus: TaskStatus) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring()) {
                task.status = Int64(newStatus.rawValue)
                try? moc.save()
            }
        }
    }

    init(task: Task) {
        self.viewModel = PostItViewModel(task: task)
        self.task = task
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title ?? "Nil")
                        .foregroundStyle(task.getColorPalette().title)
                        .font(.title3.bold())
                        .lineLimit(1)
                    
                    Text(viewModel.subtitle)
                        .foregroundStyle(task.getColorPalette().subtitle)
                        .font(.caption.bold())
                    
                    Text(task.text ?? "Nil")
                        .foregroundStyle(Color.black)
                        .font(.caption)
                        .lineLimit(4, reservesSpace: true)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Text(TaskStatus(rawValue: Int(task.status))!.toString)
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        Capsule()
                            .fill(task.getColorPalette().tag)
                    )
            }
        }
        // calling padding() makes app brick, ok cool great I absolutely love SwiftUI
        .padding()
//        .frame(width: 200, height: 200)
        .background(
            CutCornerRectangle(cornerRadius: cornerRadius)
                .foregroundColor(task.getColorPalette().background)
                .overlay(
                    TaskFlap()
                        .foregroundColor(task.getColorPalette().tag)
                )
        )
        .contextMenu {
            Menu("Alterar Status", systemImage: "arrow.triangle.2.circlepath") {
                Button("A Fazer") { updateTaskStatus(to: .toDo) }
                Button("Em Andamento") { updateTaskStatus(to: .inProgress) }
                Button("Concluído") { updateTaskStatus(to: .completed) }
            }
            Divider()
                
            Button(role: .destructive) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring()) {
                        moc.delete(task)
                        try? moc.save()
                    }
                }
            } label: {
                Label("Deletar Tarefa", systemImage: "trash")
            }
        
        }
    
    }
        
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Components/Favorite.swift\ ⁠
⁠ swift
//
//  Favorite.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct Favorite: View {
    
    @Binding var isFavorite: Bool
    
    var body: some View {
        
        Button(action: {
            withAnimation(.bouncy){
                isFavorite.toggle()
              }})
                  {
            if isFavorite {
                Image(systemName:"star.fill")
                    .font(.body.bold())
            } else {
                Image(systemName:"star")
                    .font(.body.bold())
            }
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/Components/TextOnBoarding.swift\ ⁠
⁠ swift
//
//  TextOnBoarding.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//
import SwiftUI

struct TextOnBoarding: View {
    let text: String
    let icon: String
    
    @ScaledMetric(relativeTo: .title) var tamanhoIcon: CGFloat = 27
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
                ZStack {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.accent)
                }
                .frame(width: 60, height: 60)
            
            Text(text)
                .font(.body.weight(.regular))
                .foregroundColor(.primary)
                .lineSpacing(3)
                .multilineTextAlignment(.leading)
            
        }
    }
}

#Preview {
    TextOnBoarding(text: "Encontre atalhos publicados pela comunidade e descubra novas maneiras de agilizar suas tarefas.", icon: "person.3.fill")
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/View/ProjectView.swift\ ⁠
⁠ swift
//
//  ProjetoView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

internal import CoreData
import SwiftUI

struct ProjectView: View {

    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var selectedDate: Date = Date()

    @State private var creatingNewTask: Bool = false
    @State private var editProject: Bool = false
    @State private var isNotesExpanded: Bool = false

    @State private var segmented = 0

    @ObservedObject var project: Project

    @FetchRequest
    var notes: FetchedResults<Note>

    @FetchRequest
    var tasks: FetchedResults<Task>

    var filteredTasks: [Task] {
        tasks.filter { Int($0.status) == segmented }  //Devolve array somente com o tipo da task passada no segmented
    }

    var dailyNotes: [Note] {
        notes.filter { note in
            guard let noteDate = note.date else { return false }
            return Calendar.current.isDate(selectedDate, inSameDayAs: noteDate)
        }
    }

    init(project: Project) {

        self.project = project

        _tasks = FetchRequest<Task>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.status, ascending: true)],
            predicate: NSPredicate(format: "project == %@", project)
        )

        _notes = FetchRequest<Note>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "project == %@", project)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    CustomCalendarView(
                        daySelect: daySelect,
                        projeto: project,
                        moc: moc
                    )
                    .glassEffect(in: .rect(cornerRadius: 25.0))
                    .padding(.bottom, 10)
                    Text(
                        "Anotações do dia: \(selectedDate.formatted(date: .numeric, time: .omitted))"
                    )
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        project.image == nil
                            ? .black
                            : getBrightness(
                                for: UIImage(data: project.getImage())!
                            )! > 128 ? .black : .white
                    )

                    Spacer()

                    if dailyNotes.isEmpty {
                    } else {
                        let displayedNotes =
                            isNotesExpanded
                            ? dailyNotes : Array(dailyNotes.prefix(3))

                        LazyVStack(alignment: .leading) {
                            ForEach(displayedNotes) { note in
                                NavigationLink {
                                    NoteView(note: note)
                                } label: {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(note.title ?? "Sem título")

                                                Text(note.text ?? "")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                //                                                .font(.title3)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.secondary)
                                        }
                                        if dailyNotes.last != note {
                                            Rectangle()
                                                .fill(.tertiary)
                                                .frame(height: 1)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .background(
                            .background.opacity(0.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        if isNotesExpanded && dailyNotes.count > 3 {
                            Button {
                                withAnimation(.spring()) {
                                    // Collapse the list back to 3 items
                                    isNotesExpanded = false
                                }
                            } label: {
                                Text("Mostrar menos")
                                    .font(.footnote.bold())
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Color(UIColor.systemBackground),
                                        in: Capsule()
                                    )
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 3,
                                        y: 1
                                    )
                            }
                            // This frame modifier naturally centers the button in the VStack
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                        }
                    }
                }
                .padding()
                .overlay(alignment: .bottom) {
                    // Only show the blur and button if there are > 3 notes and it's collapsed
                    if dailyNotes.count > 3 && !isNotesExpanded {
                        ZStack(alignment: .bottom) {
                            VariableBlurView(
                                maxBlurRadius: 5,
                                direction: .blurredBottomClearTop
                            )
                            .frame(height: 100)
                            .allowsHitTesting(false)  // Ensures the blur doesn't block touches

                            // The expand button
                            Button {
                                withAnimation(.spring()) {
                                    isNotesExpanded = true
                                }
                            } label: {
                                Text("Ver todas")
                                    .font(.footnote.bold())
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Color(UIColor.systemBackground),
                                        in: Capsule()
                                    )
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 5,
                                        y: 2
                                    )
                            }
                            .padding(.bottom, 15)
                        }
                    }
                }
                .background(
                    Rectangle()
                        .fill(
                            project.image == nil
                                ? project.getColorPalette().background
                                : Color(
                                    uiColor: UIImage(
                                        data: project.image!
                                    )!.dominantColor()!
                                )
                        )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 26)
                )

                Text("Tarefas do projeto \(project.getName())")
                    .font(.title2.bold())
                    .padding(.vertical, 18)

                Picker("", selection: $segmented) {
                    Text("A Fazer").tag(0)
                    Text("Em Andamento").tag(1)
                    Text("Concluído").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 10)

                LazyVGrid(
                    columns: [
                        GridItem(),
                        GridItem(),
                    ],
                    alignment: .center,
                    spacing: 10
                ) {
                    ForEach(filteredTasks) { task in
                        PostIt(task: task)
                    }
                }
                .animation(.spring(), value: filteredTasks)
                Spacer()
            }
            .padding()
        }

        .sheet(isPresented: $creatingNewTask) {
            SheetCreation(project: project)
        }
        .sheet(isPresented: $editProject) {
            SheetNewProject(project: project)
        }

        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    creatingNewTask.toggle()
                }
                Menu("", systemImage: "ellipsis") {
                    Button("Editar projeto", systemImage: "pencil") {

                        editProject.toggle()

                    }
                    Button(
                        "Deletar projeto",
                        systemImage: "trash",
                        role: .destructive
                    ) {

                        dismiss()

                        moc.delete(project)

                        try? moc.save()
                    }
                }
            }
        }
        .navigationTitle(project.getName())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inlineLarge)

    }
}

extension ProjectView {
    func daySelect(_ date: Date) {
        selectedDate = date
    }
}
 ⁠

---

### Arquivo: \⁠ ./Projetos/ProjetosApp.swift\ ⁠
⁠ swift
//
//  ProjetosApp.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import SwiftUI
internal import CoreData
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        UNUserNotificationCenter.current().delegate = self
        return true
    }

 
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

@main
struct ProjetosApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var dataController = DataController()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    NavigationStack {
                        HomeView()
                    }
                } else {
                    WelcomeView()
                }
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
 ⁠

---

