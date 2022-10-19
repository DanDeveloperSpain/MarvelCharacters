# 🕸 Marvel Characters 🕸

This project shows the list of all Marvel characters and their appearances in comics and series.

## Tools 🛠️
- Xcode 13
- Swift 5.5
- Swift Package Manager

## Libreries with SPM 📦
I have managed the external libraries with SPM, much cleaner and faster than with CocoaPods.

- RXSwift 6.5.0
  - to add reactive programming to Swift.
- RXDataSource 5.0.2
  - to extend the CollectionView reactively.
- SDWebImage 5.12.5
  - to download and manage images.
- Swinject 2.8.1
  - to create containers and handle dependency injection.

## Architecture and Design Pattern 🏗
- ### Clean Architecture 🎯
- ### MVVM 🔄
- ### Coordinator pattern 🔀
- ### Swinject ♻

Solid principles with Clean Architecture together with MVVM and coordinator pattern.

Also dependency injection is used organized in containers with Swinject library.

## Reactive Programming 🤹‍♂
All the main elements of the application are controlled with reactive programming.

**RxSwift** is used to create the observables and subscribers and **binding** them to the **UIKit elements**.

## Testing ✅
The most important parts and business logic have been tested:
- Application
  - AppCoordinatorTest
  - AppConfiguration
- Presentation
  - CharactersScene
- Domain
  - UseCases
- Data
  - Repositories
  
*I am aware that there are more classes to test.*

## Design System 🗂
I have added the implementation of an own design system (Dan Design System). 
As the application is simple, I have created a tab to show a demo of this design system.

https://github.com/DanDeveloperSpain/DanDesignSystem


## Interface 📱
The user interface is very simple since I decided to spend more time in the code and structure.

I have simulated a login in the application to create a real flow, but the Login and User screens only implement the login and logout functions.

## Others 💻

UIKit without storyboard. 1 xib for 1 viewController.

There are NSLocalizedString functions but I have not translated the app as it is a demo.


- - - -

## Installation 🔧

The libraries in this project are imported with Swift Package Manager, so you don't need to install cocoapods, just build and run👨‍💻

## APIKey 🔑

Get your API key here: https://developer.marvel.com/

No api key should be stored in a repository, end less more at a public repository.

Put your api keys in the environment variables created at Scheme arguments

1.  Go to edit shceme 
<img width="278" alt="Captura de pantalla 2021-10-07 a las 0 15 39" src="https://user-images.githubusercontent.com/22205213/136291463-677cffff-71f3-456c-b069-4841f9aca9ce.png">


2. Run option -> Arguments -> Environment Variables.
<img width="960" alt="Captura de pantalla 2021-10-07 a las 0 16 48" src="https://user-images.githubusercontent.com/22205213/136291774-d90ef207-c568-4b46-b144-6c2a819b2b2d.png">

### 🚀 READY 🚀

## License 📙
Marvel Characters is released under the MIT license. [See LICENSE](https://github.com/DanDeveloperSpain/MarvelCharacters/blob/dev/LICENSE "See LICENSE title") for details.
