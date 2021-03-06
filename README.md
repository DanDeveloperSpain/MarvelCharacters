# Marvel Characters

This project shows the list of all Marvel characters and their appearances in comics and series.

## Tools info â¹ï¸

- Xcode 13
- Swift 5.5
- Swift Package Manager

## Libreries with SPM ð ï¸
I have managed the external libraries with SPM, much cleaner and faster than with CocoaPods.
- Alamofire 5.4.4
  - for API requests.
- SDWebImage 5.12.5
  - to download and manage images.
- Swinject 2.8.1
  - to create containers and handle dependency injection.

## Architecture and Design Pattern ð

The architecture used is MVVM with Coordinator design pattern.

Also dependency injection is used organized in containers with Swinject library.

## Design System ð

I have added the implementation of an own design system (Dan Design System). 
As the application is simple, I have created a tab to show a demo of this design system.

https://github.com/DanDeveloperSpain/DanDesignSystem


## Interface ð±

The user interface is very simple since I decided to spend more time in the code and structure.

I have simulated a login in the application to create a real flow, but the Login and User screens only implement the login and logout functions.

## Others ð»

I have implemented Async/Await functions introduced in Swift 5.5.

There are NSLocalizedString functions but I have not translated the app as it is a demo.


- - - -

## Installation ð§

The libraries in this project are imported with Swift Package Manager, so you don't need to install cocoapods, just build and runð¨âð»

## APIKey ð

Get your API key here: https://developer.marvel.com/

No api key should be stored in a repository, end less more at a public repository.

Put your api keys in the environment variables created at Scheme arguments

1.  Go to edit shceme 
<img width="278" alt="Captura de pantalla 2021-10-07 a las 0 15 39" src="https://user-images.githubusercontent.com/22205213/136291463-677cffff-71f3-456c-b069-4841f9aca9ce.png">


2. Run option -> Arguments -> Environment Variables.
<img width="960" alt="Captura de pantalla 2021-10-07 a las 0 16 48" src="https://user-images.githubusercontent.com/22205213/136291774-d90ef207-c568-4b46-b144-6c2a819b2b2d.png">

### ð READY ð

## License ð
Marvel Characters is released under the MIT license. [See LICENSE](https://github.com/DanDeveloperSpain/MarvelCharacters/blob/dev/LICENSE "See LICENSE title") for details.
