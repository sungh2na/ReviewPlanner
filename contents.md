# Local Notification

- Step 1: Ask for permission
``` Swift
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print(" User gave permissions for local notifications")
            }
        }
```

- Step 2: Create the notification content
```Swift
let content = UNMutableNotificationContent()
        content.title = "Notification on a certain date"
        content.body = "This is a local notification on certain date"
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
```

- Step 3: Create the notification trigger
```Swift
var dateComponents = DateComponents()
        dateComponents.hour = 2
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
```

- Step 4: Create the request
```Swift
let request = UNNotificationRequest(identifier: "reminder" , content: content, trigger: trigger)
```

- Step 5: Register the request
```Swift
center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }

```


- 참고
    - https://www.vbflash.net/131?category=745068


# core data
 - 1. 코어 데이터 소개
    - 영속성을 위한 프레임워크
        - 데이터베이스를 이요한 저장
        - 기본 SQLite 데이터베이스 사용
        - 다수의 데이터베이스 코디네이션 가능
    - 객체 지향 접근
        - 데이터베이스를 다루는 SQL 사용 안함
        - 객체를 다루는 방버븡로 데이터 다루기
    - 데이터 모델링
        - 비주얼한 모델링 도구로 쉽게 데이터 설계
    - 데이터 설계
        - 애플리케이션에서 저장하려는 데이터 설계
        - SQLite에서 작성한 데이터 모델
            - CREATE TABLE todo (title TEXT, dueData DATE)
        - 코어 데이터를 이용한 데이터 모델
        - 데이터 모델에서 코드 생성 
    - 코어데이터 구조(스택)
        - 관리 객체 모델(NSManagedObjectModel)
            - 데이터 모델에 작성한 데이터 스키마에 대한 정보
        - 영구 저장소 코디네이터(NSPersistentStoreCoordinator)
            - 영구 저장소: NSPersistentStore, 메모리나 디스크에 저장
            - 영구 저장소를 통해서 모델에 작성한 데이터 다루기
        - 관리 객체 콘텍스트(NSManagedObjectContext)
            - 코어 데이터의 스택 중 최상단에 위치
            - 애플리케이션 작성하면서 주로 접하는 객체
            - 데이터의 생성/ 수정/ 삭제를 위한 API 제공

- 2. 코어 데이터
    - 코어데이터를 사용하는 프로젝트
        - 프로젝트 생성 시
            - 프로젝트 정보 입력
            - Use Core Data 체크
            - product name을 프레임워크 이름과 다르게 설정
     - 프로젝트 생성 후
        - CoreData 사용 준비ß
            - 데이터 모델 파일: .xcdatamodel
            - AppDelegate의 persistentContainer
        - PersistentContainer
            - persistentContainer 프로퍼티
            ```Swift
                lazy var persistentContainer: NSPersistentContainer = {
                    // 코어 데이터 준비 코드
                }
            ```
            - persistentContainer 얻기
            ```Swift
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let container = appDelegate.persistentContainer
            ```
    - 데이터 모델링
        - 데이터 모델 작성
            - 데이터 모델 편집기
            - 데이터베이스로 저장할 데이터 모델링
            - SQLite의 테이블 설계 과정
            - 데이터 모델 편집기 하단 메뉴 사용
        - 엔티티
            - 하단 메뉴로 엔티티 추가
            - 데이터의 기본 단위
            - 이름규칙: 대문자로 시작
            - RDB의 테이블
        - 어트리뷰트
            - 엔티티 내 + 버튼으로 추가
            - 엔티티의 각 항목
            - 데이터 타입 설정
            - RDB의 테이블 내 컬럼
        - 엔티티 속성
            - 엔티티에서 클래스 생성
            - 엔티티 이름
            - 추상 엔티티 설정
            - 부모 엔티티: 엔티티 상속
            - 클래스(관리 객체) 생성 속성
            - 인덱스
            - 제약사항
        - 어트리뷰트의 속성
            - 어트리뷰트는 클래스의 프로퍼티로 생성
            - transient: 실제 저장소에 저장 안함
            - optional: 선택 사항
            - indexed: 데이터베이스 인덱스
            - 어트리뷰틑 타입과 최소/최대, 기본값
- 3. 데이터 다루기
    - 기본 CRUD
        - 관리 객체 클래스 생성
            - 모델에 작성한 엔티티 -> 관리 객체 클래스
            - 엔티티 내 어트리뷰트 -> 클래스의 프로퍼티
        - 모델에서 데이터 다루기
            - 새로운 데이터 추가(Insert) -> 관리 객체 생성
            - 데이터 쿼리(Select) -> 관리 객체 얻어오기
            - 데이터 변경(Update) -> 관리 객체의 값 변경
            - 데이터 삭제(Delete) -> 관리 객체 삭제
        - 관리 객체 클래스
            - 엔티티에서 클래스 자동 생성
            - 프로젝트에 파일 추가 안됨
            - 클래스 파일은 빌드 과정에서 생성
            - NSManagedObject 자식 클래스
            - 식별 정보: objectID
            - 상태: isInserted, isUpdated, isDeleted
            - 라이프사이클: awakeFromFetch, changedValues, didSave
            - 생성된 관리 객체 클래스
            - Todo+CoreDataClass.swift
            ```Swift
            public class Todo: NSManagedObject {
            }
            ```
            - Todo+CoreDataProperties.swift
            ```Swift
            extension Todo {
                @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
                    return NSFetchRequest<Todo>(entityName: "Todo");
                }
                @NSManaged public var dueDate: NSDate?
                @NSManaged public var title: String?
            }
        - 관리 객체 클래스 파일 수동 생성
        - Entity의 속성에서 Codegen/Module 설정
        - Editor에서 Create NSManagedObject Subclass 선택
    - 새로운 객체 생성
        - Entity에서 생성한 클래스(NSManagedObject 자식 클래스) 생성
        ```Swift
        init(context moc: NSManagedObjectContext)
        ```
        - 관리 객체 콘텍스트 얻기
        - persistentContainer의 viewContext
        ```Swift
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        ```
        - 예제 코드
        ```Swift
        let todo = Todo(context: context)
        todo.title = "앱 만들기"
        todo.dueDate = Date() as NSDate
        ```
    - 데이터베이스에 반영
        - 관리 객체 생성과 속성 설정
        - 실제 데이터베이스에 반영되지 않은 상태
        - 관리 객체 콘텍스트(NSManagedObjectContext) 사용
        - 관리 객체 콘텍스트 얻기: persistentContainer의 viewContext
        ```Swift
        let container = appDelegate.persistentContainer
        let context: NSManagedObjectContext = container.viewContext 
    - 관리 객체 콘텍스트
        - 관리 객체의 라이프사이클 관리
        - 관리 객체 추가/변경/삭제/얻기 요청(FetchRequest) 실행
        - 언두(Undo)와 다시 실행(Redo)
        - 관리 객체 변경 알림(Notification)
        - 관리 객체의 변경 사항을 데이터베이스에 반영 메소드
        ```Swift
        func save() throws
        ```
    - 할 일 추가 작성
        ```Swift
        var context: NSManagedObjectContext!    // 관리 객체 콘텍스트

        override func viewDidLoad() {
            super.viewDidLoad()

            /* 관리객체 컨텍스트 준비 */
            let appDelegate = UIApplication.shared.delegate as!AppDelegate
            let container = appDelegate.persistentContainer
            context = container.viewContext
        }
        /* todo 객체 만들고 데이터 저장 */
        func addTodo(title: String, dueDate: Date) {
            let newTodo = Todo(context: context)
            newTodo.title = title
            newTodo.dueDate = dueDate as NSDate?

            do {
                try context.save()
            }
            catch let error {
                print("Error! \(error.localizedDescription)")
            }
        }
        ```
    - 저장된 데이터 확인하기
        - 코어 데이터의 기본 설정: SQLite 사용
        - 데이터베이스 저장 폴더: HOME/Library/Application Support
        - splite3 콘솔 클라이언트로 확인
         $ splite3 CoreDataTodo.splite
        - 데이터 목록보기, 테이블 구조 보기
         sqlite> .tables
         sqlite> .shema [TABLE]
        - 테이블 내 데이터 보기
         sqlite> select * from ztodo;

    - 데이터 얻기
        - 데이터를 얻기 위한 요청: NSFetchRequest
        - NSFetchRequest 얻기
        ```Swift
        let request1: NSFetchRequest<Todo> = Todo.fetchRequest()
        let request2: NSFetchRequest<Todo>(entityName: "Todo")
        ```
        - 요청 실행: NSManagedObjectContext
        ```Swift
        func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T]
        func count<T: NSFetchRequestResult>(for request: NSFetchRequest<T>) throws -> Int
        ```
        - 할 일 얻기 예제
        ```Swift
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        let todos: [Todo] = try? context.fetch(request)
        ```
    - NSFetchRequest
        - 검색 조건: predicate
        - 정렬 방식: sortDescriptors
        - 요청 갯수 설정: fetchLimit
        - 요청 시작 지점: fetchOffset
        - 요청 결과 타입: resultType
        - 연관된 객체 포함 여부: includesSubentities
        - 데이터베이스에 반영되지 않은 변경 포함 여부
         includesPendingChanges
    - 조건에 맞는 데이터 얻기
        - 조건 객체 생성: NSPredicate
        ```Swift
            init(format predicateFormat: String, _ args: CVarArgType...)
        ```
        - SAL에서 where에 해당
        - Predicate Programming Guide 참조
        - 예제: 일주일 내로 끝내야 하는 일
        ```Swift
        let predicate = NSPredicate(format: "dueDate <= %@", date)
        ```
        - 예제: 제목 비교
        ```Swift
        NSPredicate(format: "title == %@", "청소")
        NSPredicate(format: "title contains %@ And dueDate <= %@", "굉장한", week)
        ```
        - 요청 객체에 검색 조건 설정: NSFetchRequest
        ```Swift
        var predicate: NSPredicate?
        ```
        - 예제: 일주일 내로 끝내야 하는 일
        ```Swift
        let week = Date(timeIntervalSinceNow: (60 * 60 * 24 * 7)) as NSDate
        let predicate = NSPredicate(format: "dueDate <= %@", week)
        request.predicate = predicate
        let todos: [Todo] = try! context.fecth(request)
    - 데이터 정렬 방식
        - 정렬 방식: NSSortDescriptor
        ```Swift
        init(key: String?. ascending: Bool)
        ```
        - 요청 객체에 정렬 객체 설정: NSFetchRequest
        ```Swift
        var sortDescriptors: [NSSortDescriptor]?
        ```
        - 마감일로 정렬하기 예제 코드
        ```Swift
        let sort = NSSortDescriptor(key: "dueDate", ascending: true)
        request.sortDescriptors = [sort]
        ```
    - 데이터 수정
        - 관리 객체의 데이터 변경 후 저장
        - 할 일 수정하기 예제
        ``` Swift
        let todo = todos[0]
        todo.title = "새로운 할 일"
        try! context.save()
        ```
    - 데이터 삭제
        - 관리 객체 삭제 후 저장
        - NSManagedObjectContext의 삭제 API
        ```Swift
        func delete(_ object: NSManagedObject)
        ```
        - 할 일 삭제 예제
        ```Swift
        let todo = self.todoAt[0]
        context.deleteObject(todo)
        try! context.save()
        



        
// DB 
// weak, unowned
// lazy
// RestAPI
// 오픈소스 SwiftDate 사용법 익히기
// ARC(Auto Reference Counting)
// 클로저의 정의

// 가비지컬렉터

// A
// A -> B

// 1 2 -> 0
// A -> B
// 0    1
// A <- B
// 1    1
// C -> A, B
// 2    2
// C버림
// 1    1
// A <--> B
// A <--} B
// 1     

//class A {
//
//    var a: () -> Void = { [weak self] in
//        self.test()
//    }
//
//    func test() {
//
//    }
//}

// 둘다 약한참조 만들어주는데 weak은 nil은반환하고 unowned는 crash가 나서 확실때 쓴다.
// 서로 강한 참조가 발생해서 레퍼런스 카운트가 서로 1일때 하나를 weak으로 해주면 레퍼런스 카운트가 0으로 되어서 참조하는 객체가 사라지고

// 정의를 먼저 확실하게 말하기
// 그 객체가 사라지니까 참조하고있던 객체도사라짐.
// 강한참조, 약한참조 레퍼런스 싸이클 생겼을때 weak unowned를 사용하게됨.


