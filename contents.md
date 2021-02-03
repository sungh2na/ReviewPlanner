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
        let todos: [Todo] = try! context.fetch(request)
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
        ```
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
        



        
### DB 
- 여러 종류의 연관된 데이터가 서로 공유되어 효율적으로 작업을 처리할 수 있도록 저장된 데이터 집합
- 특정 조직의 여러 사용자가 공유하여 사용할 수 있도록 통합해서 저장한 운영 데이터의 집합

### 가비지 컬렉션
- 메모리가 시스템에서 더 이상 사용되지 않는것을 자동으로 찾아 해제하는 기술
- 메모리 감시를 위한 추가 자원이 필요
- 명확한 규칙이 없기 때문에 인스턴스가 언제 메모리에서 해제될지 예측 어려움

### ARC ( Autometic Reference Counting)
- 스위프트가 프로그램의 메모리 사용을 관리하기 위하여 사용하는 메모리 관리 기법
- 참조횟수를 계산해서 더이상 필요하지 않은 클래스의 인스턴스를 메모리에서 헤제하는 방식

### 강한참조
- 클래스 타입의 프로퍼티, 변수, 상수등을 선언할 때 별도의 식별자를 명시하지 않는 경우

### weak, unowned
- 강한참조로 인해 레퍼런스 사이클이 발생했을 때 인스턴스의 참조 횟수를 증가시키지 않게해서 사이클을 끊기위해 사용하는 키워드
- weak(약한참조)은 참조하던 인스턴스가 메모리에서 해제되면 nil이 할당되므로 옵셔널 변수
- unowned(미소유참조) 자신이 참조하는 인스턴스가 항상 메모리에 존재할 것이라는 전제, 참조하던 인스턴스가 해제된 후
접근하면 런타임오류

### lazy
- 지연 저장 프로퍼티 키워드
- 호출이 있을 떄 값을 초기화, 상수는 인스턴스가 완전히 생성되기 전에 초기화 되므로 변수에 사용
- 클래스 인스턴스의 저장 프로퍼티로 다른 클래스 인스턴스나 구조체 인스턴스를 할당해야 할 때

### 클로저의 정의
- 일정 기능을 하는 코드를 하나의 블록으로 모아놓은 것

### map, reduce, filter, flatmap, compactmap
- map은 컨테이너 각 요소에 매개변수로 받은 클로져 연산을 적용한 후 다른 컨테이너로 반환해주는 함수,
다른 데이터 타입으로 변경할 때 주로 쓰임.
- filter 컨테이너 내부의 값을 걸러서 추출하여 새로운 컨테이너에 반환
- reduce 컨테이너 내부의 콘텐츠를 하나로 합하는 기능을 가진 고차함수, 
전달인자로 전달받은 클로저의 연산 결과로 합해줌.
- compactmap 은 옵셔널 타입에 사용했을 때 내부 컨테이너까지 값을 추출해서 map에서 옵셔널 형태로 다시 반환되는데 반해 optional값 추출해서 반환
- flatmap은 중첩된 배열의 경우 단일 배열로 만들어줌.

### hugging priority, compression resistance priority
- 뷰가 커졌을 때 hugging priority가 더 높은 것은 설정한 크기를 유지하고 낮은 것의 크기를 늘려서 뷰를 채움
- 뷰가 작아졌을 때 compression priority 가 더 높은 것은 설정한 크기를 유지하고 낮은 것의 크기를 줄임

### 뷰컨트롤러 생명주기
- init
- Loadview
- ViewDidLoad -> 뷰 컨트롤러가 메모리에 로드됐을 때 처음 한번만 실행, 초기화
- ViewWillAppear -> 뷰 컨트롤러가 화면에 나타나기 직전 항상 실행
- ViewDidAppear -> 뷰 컨트롤러가 화면에 나타난 직후 애니메이션 등
- ViewWillDisappear -> 뷰 컨트롤러가 화면에서 사라지기 직전 호출
- ViewDidDisappear -> 뷰 컨트롤러가 완전히 사라지고 나서 호출
- ViewDidUnload
-> 앱 실행중에는 ViewWillAppear 부터 ViewDidDisappear까지 순환

### class 와 struct 차이
- class 는 reference 타입이라서 값을 참조해서 할당하고 struct는 value타입으로 값을 복사해서 할당

### 함수앞에 붙는 static과 class
- class는 상속후에 재정의 가능, static은 재정의 불가능한 메서드

### view와 layer의 차이점
- View는 이미지, 비디오, 글자 등을 보여주는 객체
- Layer는 View와 유사한 개념이기는 하지만 화면에 대한 특성만 가지고 있음
- 모든 UIView는 CALayer 객체인 layer프로퍼티를 가지고 있고 
- shadow, rounded corner, colored border 등의 기능 제공

### 객체지향 프로그래밍
- 하나의 문제 해결을 위한 데이터와 메서드를 모아놓은 것을 객체라하는데
- 각각의 객체가 서로 메시지를 주고받고 데이터를 처리하는 것을 객체지향 프로그래밍이라함

### 클래스 객체 메서드
- 클래스 -> 같은 종류(문제해결을 위한)의 집단에 속하는 속성(프로퍼티)와 행위(메서드)를 정의한 것
- 객체 -> 클래스의 인스턴스(실제로 메모리에 할당되어 동작하는 것), 고유한 속성이 있어서 클래스에서 정의한 행위를 실제로 수행
- 메서드 -> 객체가 클래스에 정의된 행위를 실질적으로 하는 함수 

### 함수형 프로그래밍
- 함수를 호출하고, 전달하고, 반환하는 등의 동작으로 프로그램을 구현

### Any, AnyObject, nil
- Any로 타입이 지정되면 그 변수 또는 상수에 어떤 종류의 데이터 타입이든지 할당 가능
- AnyObject 클래스의 인스턴스만 할당 가능
- nil 없음, 비어있음.
- Never -> optional에서

### 컬렐션
- 배열 -> 같은 타입의 데이터를 순서대로 저장
- 딕셔너리 -> 순서 없이 키와 쌍으로 구성되는 컬렉션
- 세트 -> 같은 타입의 데이터를 순서없이 하나의 묶음으로 저장, 유일한 값이어야 할 때

### 열거형
- 연관된 항목들을 묶엉서 표현할 수 있는 타입
- 정의해준 항목 값 외에는 추가/ 수정이 불가
- 제한된 선택지/ 정해진 값 외에는 받기 싫을 떄 / 예상된 입력값이 한정되어 있을 떄 
- enum

### 옵셔널
- 값이 있을 수도 없을 수도 있음으르 나타냄 

### 구조체 클래스
- 둘다 프로퍼티와 메서드를 사용하여 사용자 정의 데이터 타입을 만들어 주는 것 
- 서브스크립트 정의, 이니셜라이저 정의, 익스텐션을 통해 확장, 프로토콜 준수

- 구조체의 인스턴스는 값 타입이고 클래스의 인스턴스는 참조 타입
- 클레스에서만 상속 가능, 타입캐스팅 가능, 디이니셜라이저 가능, 레퍼런스카운팅 계산 가능

### 값타입과 참조타입
- 값타입 -> 어떤 함수의 전달인자로 전달될 떄 값이 복사되어 전달
- 참조타입 -> 전달인자 전달될 떄 참조(주소)가 전달

### 프로퍼티 메서드
- 프로퍼티 -> 클래스, 구조체 또는 열거형 등에 관련된 값
- 메서드 -> 특정 타입에 관련된 함수

# 저장프로퍼티, 연산프로퍼티, 타입프로퍼티
- 저장-> 클래스 또는 구조체 인스턴스와 관련된 값 저장하는 프로퍼티
- 연산-> 특정 상태에 따른 값을 연산하는 프로퍼티 , 접근자, 설정자
- 타입-> 각각의 인스턴스가 아닌 타입 자체에 속하는 프로퍼티, 변수로 선언, 초기값 반드시, 지연연산

# mutating
- 구조체나 열거형 등의 값타입에서 해당 메서드가 인스턴스 내부의 값을 변경한다는 것을 의미

# 타입 메서드 (static,public)
- 타입 자체에서 호출 가능한 메서드
- static -> 상속후 재정의(override) 불가능
- public -> 상속후 재정의 가능

### 접근 수준
- 개방 접근수준 - open
- 공개 접근수준 - public
- 내부 접근수준 - internal
- 파일외부비공개 접근수준 - fileprivate
- 비공개 접근수준 - private

### 옵셔널 처리하는 방법( 옵셔널 체이닝, 빠른 종료)
- 옵셔널 체이닝 -> 옵셔널 변수나 상수 뒤에 물음표 붙여서 메서드나 프로퍼티 가져옴 
- 빠른 종료 -> guard, true일 때 실행

### 서브스크립트
- 클래스, 구조체, 열거형에서 컬렉션, 리스트, 시퀀스 등 타입의 요소에 접근하는 단축 문법
- 인스턴스 이름 뒤에 대괄호 써서 인스턴스 내부의 특정 값에 접근 

### 상속
- 클래스에서 상속을 받으면 자식클래스는 부모클래스의 프로퍼티, 메서드 사용 재정의 가능
- 재정의(override) -> 물려받은 프로퍼티, 메서드등을 그대로 사용하지 않고 변경하여 사용
- 재정의 방지, 상속 방지 -> final 키워드

### 스위프트 타입캐스팅 (is, as)
- is -> 타입 확인 연산자, 인스턴스가 해당 클래스의 인스턴스거나 그 자식클래스의 인스턴스라면 true, 특정 프로토콜준수 확인
- as -> 다운캐스팅, 부모클래스 타입을 자식클래스의 타입으로 캐스팅, 다른 프로토콜로 다운캐스팅시도?, 강제!
                                                                                                                 
### 프롵토콜
- 특정 기능을 실행하기 위해 필요한 요구사항을 정의한 것 

### 위임을 위한 프로토콜 (Delegation)
- 클래스나 구조체가 자신의 책임이나 임무를 다른 타입의 인스턴스에게 위임하는 디자인 패턴
- 책무를 위임하기 위해 정의한 프로토콜을 준수하는 타입은 자신에게 위임될 일정 책무를 할 수 있다는 것을 보장
- 위임은 사용자 특정 행동에 반응하기 위해 사용되기도 하며, 비동기 처리에도 많이 사용됨
- 위임패턴은 애플의 프레임워크에서 사용하는 주요한 패턴 중 하나
- 예를들어 UITableView타입의 인스턴스가 해야하는 일을 위임받아 처리하는 인스턴스는 UITableViewDelegate 프로토콜 준수하면 됨
- 위임받은 인스턴스, 즉 UITableViewDelegate프로토콜을 준수하는 인스턴스는 UITableView의 인스턴스가 해야하는 일을 대신 처리해줄 수 있음

### 익스텐션
- 구조체, 클래스, 열거형, 프로토콜 타입에 새로운 기능을 확장할 수 있음

### 제네릭
- 어떤 타입이 들어올 지 모를 때 사용, 다양한 타입을 처리할 수 있게 할때 사용

### 운영체제
- 컴퓨터의 하드웨어를 제어하고 응용 소프트웨어를 위한 기반 환경을 제공하며, 사용자가 컴퓨터를 사용할 수 있도록 중재 역할을 해주는 소프트웨어

### 프로그램 프로세스
- 파일시스템에 등록되어있는 메모리상에 올라가있지 않은 상태
- 메모리에 올라가있는 프로그램 (실행중인 프로그램)
- 스택, 힙, 데이터, 텍스트로 구성된 독립적인 메모리 영역을 가지고 한개 이상의 스레드 포함
- 멀티프로세스는 하나의 응용프로그램을 여러개의 프로세스로 구성하여 작업 처리 컨텍스트 스위치 오버헤드 큼
- 스레드는 프로세스 내부의 실행 흐름, code data heap 공유하고 stack만 따로 사용 같은 프로세스내에 있으므로 데이터 공유가 쉬움, 충돌

### MVC
- Controller가 View와 Model사이에서 중재자 역할을 하여 유저와 상호작용은 물론 모델 데이터도 처리한다
- Model: 애플리케이션에서 사용하는 데이터와 데이터 처리부
- View: 사용자 인터페이스로 화면에 대한 직접적인 접근을 담당
- Controller: 사용자 입력처리 및 모델변화를 감지하여 화면 갱신
- 특징 Controller는 여러개의 View를 선택할 수 있는 1:N구조
- Controller는 View를 선택할 뿐 직접 업데이트하지 않음( View는 Controller 알지 못함)
- 장점 - 단순하여 보편적으로 많이 사용함
- 단점 - View와 Model사이의 의존성이 높음 

### MVVM
- Model: 애플리케이션에서 사용하는 데이터와 데이터 처리부
- View: 사용자 인터페이스로 화면에 대한 직접적인 접근을 담당
- ViewModel: View를 표현하기 위해 만든 View를 위한 Model
    - View를 나타내주기 위한 Model이자 Miew를 나타내기 위한 데이터를 처리함
- 특징 Command 패턴과 Data Binding을 사용하여 View와 ViewModel사이의 의존성을 제거함
- View를 통해 입력이 들어오면 커맨드 패턴을 통해서 ViewModel에 명령을 내리게 되고, 데이터 바인딩을 통해
viewModel의 값이 변화하면 View의 정보가 바뀌게 됨.
- ViewModel과 View는 1:N관계
- 각각의 부분이 독립적이기 때문에 모듈화하여 개발하기 용이하나 ViewModel 개발이 어려움

### NotificationCenter
- register된 observer들에게 정보를 broadcast 할 수 있게 해주는 dispatch mechanism이다.
- addObserver(_:selector:name:object:) 등 을 통해 Observer를 추가하고, 관찰을 시작한다.
- event가 발생하면 Object는 Notification center에게 notifiction을 post(송신) 한다.
- Notification center는 모든 registered Observer들에게 해당 내용을 Broadcast 한다.
- Observer들은 발생한 event에 대한 처리를 한다.


 ## 스위프트 관련
- 클래스와 스트럭트의 차이
클래스는 reference타입 참조해서 할당
스트럭트는 value타입  값을 복사해서 할당
클래스만 상속, 레퍼런스 카운팅, 디이니셜라이저, 타입캐스팅 가능

- compactMap, map 차이
map은 컨테이너의 요소에 매개변수로 받은 클로저 연산을 해서 다른 컨테이너로 반환, 데이터 타입 변환할 때 주로 쓰임
옵셔널 컨테이너에서 map을 쓰면 옵셔널로 반환하고 compactMap 쓰면 옵셔널 내부의 값 추출하고 nil 없이 반환

- Lazy Property
호출될때 값을 할당함.
클래스의 저장 프로퍼티에 다른 클래스 인스턴스 넣을 때 사용

- Access Level
Open 정의 모듈의 모든 소스파일 내에서 사용 가능, 외부 모듈에서 사용 가능, 상속 오버라이딩 가능
Public 정의 모듈의 모든 소스파일 내에서 사용 가능, 외부 모듈에서 사용 가능, 상속 오버라이딩 불가능
Internal 기본 설정, 정의 모듈의 모든 소스파일 내에서 사용가능, 다른 모듈에서 사용 불가능
File private 같은 파일 내에서만 사용가능
Private 클래스 내부에서만 사용 가능

- 클로져
일정 기능을 하는 코드를 하나의 블록으로 모아놓은 것
익명함수, 함수매개변수나 반환값으로 사용가능

- nonescaping , escaping
함수의 전달인자로 전달한 클로저가 종료후에도 호출될 때 @escaping 키워드를 사용하여 클로저를 탈출한다고 명시
함수 종료후에 사용되지 않으면 nonescaping

- Array vs Set vs Dictionary
Array 같은 타입의 데이터를 순서대로 넣은 컬렉션
Set 같은 타입의 데이터의 묶음, 유일한 값이어야 함, hashable
Dictionary 키와 쌍으로 된 데이터를 순서 없이 저장, 키는 hashable

// RestAPI
// 오픈소스 SwiftDate 사용법 익히기