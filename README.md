#  Photobox app

### 목차
- [1️⃣ 프로젝트 소개](#-프로젝트-소개)
- [2️⃣ 프로젝트 안에서 고민한 것들](#-프로젝트-안에서-고민한-것들)
- [3️⃣ 프로젝트 구현 조건](#-프로젝트-구현-조건)

### 프로젝트 소개

- 기본 소개
    - Unslash Open API를 활용하여 사진 데이터를 조회하고, 조건에 맞게 검색하고, 좋아요한 사진을 모아보는 앱

- 구현 기간
    - 1차: 2024.07.22 ~ 07.29
    - 2차: 2024.07.31 ~ 08.02
    - 3차: TBD

- 구현 방식
    - `Custom Observable` 객체를 활용하여 **MVVM 패턴**으로 코드 적용
    - `URLSession dataTask`를 통한 비동기 데이터 통신 및 `Task + Async/Await` 를 활용한 비동기 코드 활용
    - `Realm Swift` 라이브러리를 활용하여 좋아요한 사진 데이터 백그라운드에 저장
    - `FileManager API`를 활용하여 로컬에 좋아요한 사진 이미지 저장/조회/삭제
    - `DiffableDataSource`, `CollectionViewCompositionalLayout`을 활용한 컬렉션 뷰 구현
    - `DGChart` 라이브러리를 활용하여 LineChart 구현
    
- 폴더링

```
├── photobox
│   ├── App
│   ├── Presentation
│   │   ├── Profile
│   │   │   ├── ViewController
│   │   │   ├── ViewModel
│   │   ├── Topic
│   │   ├── Search
│   │   ├── LikeList
│   │   ├── Search
│   │   ├── Detail
│   ├── Views
│   ├── Models
│   ├── Presentation
│   ├── Service
│   │   ├── Network
│   │   ├── Route
│   │   ├── Validation
│   │   ├── UserDefaults
│   │   ├── FileManage
│   ├── Model
│   ├── Utility
│   ├── Protocol
└── └── Constants

```

- 구현된 앱 스크린샷

|1. 계정 설정|2. Topic 테이블|3. 사진 디테일|
|-|-|-|
|<img width="200" src="https://github.com/user-attachments/assets/93539ed4-8234-4f45-85fe-2851fd798999" />|<img width="200" src="https://github.com/user-attachments/assets/07b0e708-15bb-4382-aa9c-db3ddcddb930" />|<img width="200" src="https://github.com/user-attachments/assets/d8357185-23b4-4489-9492-5461b6b1a3e3" />|

|4. 랜덤 사진 목록|5. 사진 검색 및 필터 목록|6. 좋아요한 사진 목록|
|-|-|-|
|<img width="200" src="https://github.com/user-attachments/assets/6b9614a2-1522-45a7-b039-8dde4008fc37" />|<img width="200" src="https://github.com/user-attachments/assets/c1750e6c-7915-47c4-81fc-0ac94ef4a0b7" />|<img width="200" src="https://github.com/user-attachments/assets/4516b712-a83c-43da-a5d3-642a39c73a7a" />|

<br />

### 프로젝트 안에서 고민한 것들

1. ProfileSetting 페이지에서 MBTI 버튼 구현을 위한 output 객체를 만들어 터치에 따라 VStack이 새롭게 그려지도록 코드를 작성했습니다.
   - 처음에는 모든 MBTI 속성에 대한 버튼 객체를 각각 만들어야 할 것 같다고 생각했지만, -> **반복되는 코드가 너무 많이 생길 것이라 판단했습니다.**
   - 각 MBTI 속성 그룹에 대해서 <u>선택된 값이 있는지 / 선택된 값이 없다면 선택 / 이미 선택된 걸 다시 선택한다면 해제</u> 해주는 처리를 반복처리 해줄 수 있는 로직을 만들고,
   - (ex. I와 E는 하나의 속성 그룹에 분류되어, 두 요소 사이에서 터치 이벤트를 다르게 처리해줘야 했습니다. 즉, S/N, F/T, J/P가 각각의 그룹으로 다르게 처리 필요.)
   - 로직 내부에서 스택 객체를 만들어 뷰에 업데이트 해주는 형식으로 구현하면 될 것이라고 판단했습니다.
   - MBTI 설정 뷰를 랜더하는 ViewController에서는 ViewModel의 output이 업데이트 될 경우, 해당 로직이 바인딩되어 돌아갈 수 있도록 설정해주었습니다.
   - 버튼 터치 이벤트가 발생할 때마다, 전체 스택 객체를 다시 만들어 다시 삽입하는 오버 랜더링이 발생할 수 있을 것 같아서 각각의 그룹 스택을 감싸는 전체 스택 객체는 따로 외부에서 정의하여 사용하는 방향으로 수정해보는 것도 좋을 것 같다는 생각을 가지고 있습니다.
     
   ```swift
   // ProfileSettingView
   func generateMBTI(by mbtiArray: [[MbtiButton]], target: Any?, action: Selector) {
        // 전체 스택을 만들고
        let totalStack = UIStackView()
        totalStack.alignment = .center
        totalStack.distribution = .fillEqually

        // 버튼 터치 여부를 반영한 버튼 그룹을 만들어서        
        let mbtiViews = mbtiArray.map { $0.map {
            let btn = CircleButton(for: $0.value)
            btn.isSelected = $0.isSelected
            return btn
        } }

        // 각 속성별로 개별 스택을 만들어 배열로 준비
        mbtiViews.enumerated().forEach { idx, buttons in
            let stack = UIStackView()
            buttons.forEach {
                $0.tag = idx
                $0.snp.makeConstraints { make in
                    make.size.equalTo(50)
                }
                $0.addTarget(target, action: action, for: .touchUpInside)
                stack.addArrangedSubview($0)
            }
            stack.distribution = .fillEqually
            stack.spacing = 8
            stack.alignment = .center
            stack.axis = .vertical
            totalStack.addArrangedSubview(stack)
        }

        // 전체 스택에 각 그룹별 스택을 삽입
        mbtiBox.setUpContentsView(by: totalStack)
    }

   // ProfileSettingViewController
   {
       ...
       view.generateMBTI(by: viewModel.mbtiOutput.value, target: self, action: #selector(onTouchMBTIbutton))
   }
   ```

2. TopicVC, RandomVC, SearchVC, LikeListVC, DetailVC 모든 ViewModel에 구현된 like / dislike 로직이 반복되는데, ViewModelProtocol을 확장해서 로직을 재사용할 수 없을까?
    - 메인 화면안에 있는 모든 ViewController에 연결된 ViewModel에서 각각 아래의 거의 동일한 로직으로 like, dislike 이벤트가 처리되고 있었습니다.
        ```swift
        private func photoLikeHandler() {
            
            if photo.isLiked {
                0. 이미 좋아요를 한 사진 -> dislike logic
                1. fileManager에서 이미지를 삭제하고
                switch 1의 결과 {
                    2. repository에서 이미지 레코드 삭제하고
                    switch 2의 결과 {
                        3. 여기서 각 viewmodel의 이벤트 처리
                    }
                }
                
            } else {
                0. 좋아요를 할 사진 -> like logic
                0. 좋아요를 할 사진에 대한 정확한 데이터를 networkService에서 fetch하고
                switch 0의 결과 {
                    1. fileManager에서 이미지 추가하고
                    switch 1의 결과 {
                        2. repository에서 이미지 레코드 추가하고
                        switch 2의 결과 {
                            3. 여기서 각 viewmodel의 이벤트 처리
                        }
                    }
                }
            }
        } 
        ```
    - 위의 코드 0 ~ 2에 해당하는 부분은 모든 viewModel에서 동일하게 가지고 있었기 때문에, 이 부분을 모든 viewModel이 채택하고 있는 ViewModelProtocol에서 메서드로 확장하여 분리하였습니다.
    - 각 viewModel 내부에서 핸들링이 필요한 로직은 completionHandler 형태의 클로저로 받아, 해당 시점에 구현될 수 있도록 처리하였습니다.
        ```swift
        func disLikeHandler(
            fileManager: FileManageService,
            repository: LikedPhotoRepository,
            by photoId: String,
            handler: @escaping (Result<String, any Error>) -> Void
        ) {
            let removeResult = fileManager.removeImage(for: photoId)
                
            switch removeResult {
            case .success(_):
                DispatchQueue.main.async {
                    let dbResult = repository.deleteLikedPhotoById(by: photoId)
                        
                    switch dbResult {
                    case .success(let success):
                        handler(.success(success))
                    case .failure(let failure):
                        handler(.failure(failure))
                    }
                }
            case .failure(let failure):
                handler(.failure(failure))
            }
        }
        ```
    - like, dislike를 위한 메서드를 구분하여 확장하였습니다. viewModel에서 호출할 때, 조금 더 역할이 명확하게 정의된 메서드를 프로토콜 자체에서 불러와 사용할 수 있어 중복 구현 없이 코드를 재사용할 수 있었습니다.

3. tbd

<br />

### 프로젝트 구현 조건

<details>
    <summary>Basic Implementation Requirements </summary>
    
    - [x] 기본 조건
        - [x] 프로젝트는 MVVM 아키텍처, Observable 패턴을 기반으로 코드 작성
        - [x] Realm, FileManager를 활용하여 사진 자료에 대한 저장 구현

    - [x] Utility
        - [x] NetworkService : 명확한 Error 처리 구현, URLSession+Async로 구현
        - [x] RouteService : Enum 형태로 구현
        - [x] UserDefaultService : 닉네임, 프로필 이미지, MBTI 값 저장
        - [x] RealmRepository : 좋아요 관리 목적 (+ 파일 매니저 이미지 저장 주소 관리)
        - [x] FileManageService : local documents에 이미지 저장, 조회, 삭제 관리
        
    - [x] 스플래시
        - [x] 2초간 노출
        - [x] 유저 데이터 생성에 따라 온보딩 / 메인 화면으로 이동

    - [x] 온보딩
        - [x] 유저 데이터가 없을 경우, 프로필 생성 페이지로 이동 (버튼 터치)

    - [x] 프로필 설정
        - [x] MVVM 패턴으로 구현
        - [x] 프로필 이미지, 프로필 닉네임, MBTI 설정 UI
        - [x] 모든 조건 충족시 유저 데이터 생성 가능
        - 프로필 이미지
            - [x] 최초 접근시 랜덤 이미지
            - [x] 프로필 이미지 설정 페이지에서 선택한 이미지로 픽스
        - 프로필 닉네임
            - [x] 2이상 ~ 10자 미만
            - [x] 특수문자(@, #, $, %), 숫자 포함 불가
            - [x] 닉네임 조건 검증에 따라 인디케이팅 레이블 보여주기 
        - MBTI 선택
            - [x] 최초에는 아무 항목도 선택되지 않음
            - [x] 각 항목별로 한 개의 성향만 선택할 수 있고, 동일한 항목을 터치할 경우 해제된다.
            - [x] MVVM 패턴으로 데이터 - 뷰 맵핑하기
            
    - [x] 프로필 이미지 설정
        - [x] 프로필 설정 페이지에 선택되어 있는 이미지를 최초에 노출
        - [x] 이미지 컬렉션에서 선택된 이미지를 상단 이미지에 변경하여 노출
        - [x] 이미지 선택 후 프로필 설정 페이지로 돌아올 경우, 선택된 이미지가 노출

    - [x] 메인 화면 (탭-1) - 토픽별 사진
        - [x] 토픽: 골든 아워, 비즈니스 및 업무, 건축 및 인테리어
        - [x] 토픽별 사진 갯수: 10
        - [x] 토픽 UI: 가로 스크롤형 컬렉션 뷰
        - 컬렉션 아이템
            - [x] 배경: 이미지
            - [x] 좋아요 수: API 통신으로 조회한 이미지 별 좋아요 수 노출
            - [x] 좋아요 버튼: 유저가 직접 터치하여 좋아요 반영
        - [x] MVVM 패턴으로 교체
        
    - [x] 사진 검색 화면 (탭-3)
        - [x] Photo Search API 활용하여 검색한 키워드에 맞는 이미지 노출
        - [x] 기본 데이터 갯수: 20
        - [x] 스크롤 기반 페이지네이션 구현
        - [x] 컬렉션 아이템은 메인 화면의 것과 동일
        - 정렬
            - [x] default: 관련순
            - [x] 다른 선택지: 최신순, 인기순

    - [x] 좋아요 목록 (탭-4)
        - [x] 탭-1~3에서 조회한 이미지별 좋아요를 터치한 이미지만 모아서 노출
        - [x] 탭-3의 정렬, 필터 기능 동일하게 제공
        - [x] 좋아요 취소할 경우, 목록에서 삭제
        - [x] 좋아요 한 사진이 없는 경우 "저장된 사진이 없어요" 레이블 노출

    - [x] 사진 상세 화면
        - [x] MVVM 패턴으로 구현
        - [x] 탭-1~4에서 노출되는 모든 아이템 셀 터치할 경우 상세 화면으로 이동
        - [x] 좋아요 취소, 선택 가능
        - [x] 이미지뷰 크기는 고정
        - [x] 정보까지 노출

    - [x] 프로필 수정 화면
        - [x] 프로필 설정 화면과 UI 동일
        - [x] 완료 버튼 대신 `회원 탈퇴` 레이블 버튼 반영
        - [x] 닉네임, 이미지, MBTI 수정 가능

</details>

---

Advanced Requirements

- [x] DetailView
    - [x] 스크롤 뷰 반영하여 이미지 사이즈에 맞게 스크롤 크기 반영 (maxHeight: 500)
    - [x] statistics 데이터 기반으로 차트 구현
    
- [ ] TopicView
    - [x] 랜덤 토픽 랜더링 되도록 설계
    - [x] 당겨서 새로고침하여 페이지 새롭게 랜더링
    - [ ] skeleton 라이브러리 활용해보기
    
- [x] RandomImageView
    - [x] randomAPI를 사용해서 전체 페이지 기반의 컬렉션 뷰 구현

- [x] SearchView
    - [x] 색감 선택 버튼 컬랙션
