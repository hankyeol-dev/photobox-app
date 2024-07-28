#  Photobox app

### 목차
- [1️⃣ 프로젝트 소개](#-프로젝트-소개)
- [2️⃣ 프로젝트 Flow](#-프로젝트-Scene-Flow)
- [3️⃣ 프로젝트 구현 조건](#-프로젝트-구현-조건)
- [4️⃣ 프로젝트 안에서 고민한 것들](#-프로젝트-안에서-고민한-것들)

### 프로젝트 소개

- 구현 기간: 2024.07.22~
(tbd)

<br />

### 프로젝트 Scene Flow
(tbd)

<br />

### 프로젝트 안에서 고민한 것들

- 왜 네비게이팅 패턴이 잘 먹히지 않았을까? (삽질을 많이 했지만 잘 해결하지 못했음)
- sender?() 와 같이 클로저로 값을 캡쳐하는 경우에는 클로저 정의를 ViewModel에서 하는게 맞을까 아니면 ViewController, View 또는 필요한 곳마다 하는게 좋을까?
(TBD)

<br />

### 프로젝트 구현 조건

Basic Implementation Requirements

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
    
- [ ] 사진 검색 화면 (탭-3)
    - [x] Photo Search API 활용하여 검색한 키워드에 맞는 이미지 노출
    - [x] 기본 데이터 갯수: 20
    - [x] 스크롤 기반 페이지네이션 구현
    - [x] 컬렉션 아이템은 메인 화면의 것과 동일
    - 정렬
        - [x] default: 관련순
        - [x] 다른 선택지: 최신순, 인기순
    - 필터
        - [ ] 색감 선택 버튼 (레드, 퍼플, 그린, 블루)

- [x] 좋아요 목록 (탭-4)
    - [x] 탭-1~3에서 조회한 이미지별 좋아요를 터치한 이미지만 모아서 노출
    - [x] 탭-3의 정렬, 필터 기능 동일하게 제공
    - [x] 좋아요 취소할 경우, 목록에서 삭제
    - [x] 좋아요 한 사진이 없는 경우 "저장된 사진이 없어요" 레이블 노출

- [x] 사진 상제 화면
    - [x] MVVM 패턴으로 구현
    - [x] 탭-1~4에서 노출되는 모든 아이템 셀 터치할 경우 상세 화면으로 이동
    - [x] 좋아요 취소, 선택 가능
    - [x] 이미지뷰 크기는 고정
    - [x] 정보까지 노출

- [x] 프로필 수정 화면
    - [x] 프로필 설정 화면과 UI 동일
    - [x] 완료 버튼 대신 `회원 탈퇴` 레이블 버튼 반영
    - [x] 닉네임, 이미지, MBTI 수정 가능
