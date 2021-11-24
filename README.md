# BudgetManager
## Project Blue Print
입금/지출 관리             |  달력 및 검색         |  월별 리포트 및        
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://user-images.githubusercontent.com/48948578/142340227-b902e17d-da5d-46e6-9d5b-af8029a45463.jpg" alt="drawing" width="350"/>  |  <img src="https://user-images.githubusercontent.com/48948578/142336726-62912586-02b7-4ce1-8691-9ac5acd3dc06.jpg" alt="drawing" width="350"/>       |<img src="https://user-images.githubusercontent.com/48948578/142336730-440e6f0e-74da-4791-a463-4fa70e64626f.jpg" alt="drawing" width="350"/>




## Project
 - 프로젝트 개발 기간 : 2021.11.14 ~ 2021.12.12
 - 프로젝트 구성 인원 : 1명
 - 형상 관리 : Github
   
## Objectives
 - 사용자가 가계부를 작성하여 자신의 소비를 데이터화 할 수 있게 하기
 - 데이터화된 소비를 통해 불필요한 소비를 인식하고 줄이게 하기

## Approach
 - Swift
 - Realm
 - FScalendar - https://github.com/HeroTransitions/Hero
 - Hero - https://github.com/HeroTransitions/Hero
 - Almofire
 - Kakao OCR API 



## Workplan

1. 이터레이션 2 (어플의 큰 틀 잡기)
(2021/11/18 ~ 2021/11/21)
2. 이터레이션 3 (기본적 기능 구현)
(2021/11/22 ~ 2021/11/24)
3. 이터레이션 4 (기능 마무리)
(2021/11/25 ~ 2021/11/28)
4. 이터레이션 5 (어플 출시)
(2021/11/29  ~ 2021/12/01)

<br/>

이터레이션 2 (어플의 큰 틀 잡기)  <br/>(2021/11/18 ~ 2021/11/21) | 완료 날짜 | 예상 소요 시간 | 실제 소요 시간
--- | --- | --- | --- 
전체적 디자인 설정 | 11/21 | 2H | 2H 
Realm 데이터 구조 및 프로젝트 적용 | - | 3H | - 
StoryBoard 기본 틀 잡기 | 11/18 | 1H | 30M 
화면 전환  | 11/21 | 2H | 2H 
아이콘 등 UI에 필요한 이미지 얻기 | 11/19 | 2H | 2H 
UI 구성 (적용할 애니메이션 생각 Hero)  | - | 2H30M | - 
FSCalendar 공부  | - | 3H | - 
Library 설치  | 11/18 | 15M | 15M 
이터레이션 진행 평가 (Readme 정리)  | - | 1H30M | - 

이터레이션 2 
SB를 나누어 tab bar를 만들때, 새로운 SB VC에 tab bar item 추가하면 bar 생김.
생각보다 fscalendar custom 하기 어려웠다. 기능들을 먼저 구현하고 구체적 ui를 생각해보자.
이터레이션 3은 기능 위주, 이터레이션 4에서 UI마무리 하기로 결정.
이터레이션을 진행하면서 계획했던 것과 다르게 진행하는 부분들이 생김, 힘들어 보이는 기능을 뒤로 미루고 가능한 기능을 먼저 구현해서 발생하는 것 같음.
빠르게 기능을 먼저 구현하고 디자인은 마지막 이터레이션에서 진행하기로 결정.

이터레이션 3 (어플의 기능 구현하기)  <br/>(2021/11/22 ~ 2021/11/24) | 완료 날짜 | 예상 소요 시간 | 실제 소요 시간
--- | --- | --- | --- 
전체적 디자인 설정 | - | 2H | 2H 
Main Sb 기능 구현 | 11/23 | 3H | 2H 
Calendar Sb 기능 구현 | 11/23 | 3H | 3H 
화면 전환  | - | 2H | - 
Report Sb 기능 구현 | - | 2H | 4H 
Setting Sb 기능 구현  | - | 2H30M | - 
이터레이션 진행 평가 (Readme 정리)  | - | 1H30M | - 

이터레이샨 3 확실히 기능을 먼저 구현하려 하니까, 개발 속도가 빨라짐. 각 SB 기준으로 할일 단위를 정하는 것이 앞으로 좋을거 같음.
11/23일 Main SB, Calendar Sb 구현했으니 24일 까지 Report Sb, Setting SB 구현 계획.



