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
 - FScalendar
 - Almofire 



## Workplan

1. 이터레이션 2 (어플의 큰 틀 잡기)
(2021/11/18 ~ 2021/11/21)
2. 이터레이션 3 (어플의 기능 구현하기)
(2021/11/22 ~ 2021/11/24)
3. 이터레이션 4 (어플의 디자인 구현하기)
(2021/11/25 ~ 2021/11/28)
4. 이터레이션 5 (어플 출시)
(2021/11/29  ~ 2021/12/01)

<br/>

이터레이션 2 (어플의 큰 틀 잡기)  <br/>(2021/11/18 ~ 2021/11/21) | 완료 날짜 | 예상 소요 시간 | 실제 소요 시간
--- | --- | --- | --- 
전체적 디자인 설정 | 11/21 | 2H | 2H 
Realm 데이터 구조 및 프로젝트 적용 | 11/21 | 3H | 2H 
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
Report Sb 기능 구현 | 11/24 | 2H | 5H 
Setting Sb 기능 구현  | 11/24 | 2H30M | 1H 
이터레이션 진행 평가 (Readme 정리)  | 11/24 | 1H30M | 1H 

이터레이션 3 확실히 기능을 먼저 구현하려 하니까, 개발 속도가 빨라짐. 각 SB 기준으로 할 일 단위를 정하는 것이 앞으로 좋을거 같음.
<br/>
11/23일 Main SB, Calendar Sb 구현했으니 24일 까지 Report Sb, Setting SB 구현 계획.
<br/>
11/24 Report Sb 구현에 생각 보다 많은 시간이 들어 setting sb의 백업 복구 기능 완성 못함. 이터레이션 4의 디자인 부분 끝난 후 추가 기능으로 업데이트 할 예정.


이터레이션 4 (어플의 디자인 구현하기)  <br/>(2021/11/25 ~ 2021/11/28) | 완료 날짜 | 예상 소요 시간 | 실제 소요 시간
--- | --- | --- | --- 
Main Sb 디자인| 11/25 | 3H |  4H
Calendar Sb 디자인 | 11/26 | 3H | 5H
Report Sb 디자인 | 11/27 | 3H | 4H
Setting Sb  디자인 | 11/28 | 3H | 3H
화면 전환  | 11/28 | 2H | 2H 
이터레이션 진행 평가 (Readme 정리)  | 12/01 | 1H30M | 1H 

이터레이션 4
11/25 - 기존에 비해 이터레이션을 SB 단위로 잡아 훨씬 계획에 맞게 일하기 편해짐. 디자인에 대하여 많이 고민했는데 Pinterest 싸이트를 추천 받아 괜찮은 디자인을 적용하기로 결정하여 문제해결. 어울리는 색 찾기가 힘들었고 디자인이 다듬어지자 어플 보기가 훨씬 편해짐
https://elements.envato.com/my-wallet-app-ios-android-ui-kit-template-2-DL79VK3?irgwc=1&clickid=xvmRKHwfCxyIUCV11SXiZ0LvUkG2gXQTj3p6UQ0&iradid=628379&utm_campaign=elements_af_177595&iradtype=TEXT_LINK&irmptype=mediapartner&utm_medium=affiliate&utm_source=impact_radius&mp=ksioks 참고하는 

이터레이션 5 (출시 준비)  <br/>(2021/11/29 ~ 2021/12/01) | 완료 날짜 | 예상 소요 시간 | 실제 소요 시간
--- | --- | --- | --- 
기능 마무리 작업| 11/30 | 4H |  4H
디자인 마무리 작업 | 11/30 | 4H | 5H
앱출시 위해 스크린 샷| 11/30 | 1H | 1H
앱출시 위한 정보 작성 | 12/01 | 1H | 1H
이터레이션 진행 평가 (Readme 정리)  | 12/01 | 30M | 20M 

12/01 성공적으로 앱 제출하였고, 현재 앱 심사 중이다.

이터레이션 6 (출시 대기, 휴식 및 코드 정리)  <br/>(2021/12/01 ~ 2021/12/05) | 완료 날짜 | 예상 소요 시간 | 실제 소요 시간
--- | --- | --- | --- 
출시 상태 확인| 12/03 | 1H |  1H
코드 정리| 12/05| 4H |  3H

 (Readme 정리)  | 12/01 | 30M | 20M 
12/03 앱 성공적으로 출시 완료
중복 코드 함수로 묶어서 줄임. 



