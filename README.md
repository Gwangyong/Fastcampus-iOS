## 패스트캠퍼스 iOS 강의 실습

본 레파지토리는 패스트캠퍼스 iOS강의를 보고 작성한 코드들을 기록하는 공간입니다.


### Part 3. Intermediate의 Spotify 로그인 구현 CH01_08 Google 로그인 부터는 하지못함.
- 5.0.2버전으로 설치한 경우. [프로젝트명]/Pods/GoogleSignIn/Frameworks/GoogleSignIn.framework/GoogleSignIn' for architecture arm64 문제가남.
- pods -> Build Settings -> Architectures -> Debug랑 Release 둘 다 Any iOS SDK 에 arm64로 설정해주었지만 되지않음. 
- 질문을 올려뒀으니 해결되는대로 다시 Google Auth 구현해야함.
