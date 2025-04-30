Clear-Host

$originalPath = $env:Path

$env:JAVA_HOME = "D:\z2025_1\Android\Studio\jbr"
$env:ANDROID_HOME = "D:\z2025_1\Android\SDK\"
## Studio\bin\studio64.exe

## adb.exe 
## java.exe 
## emulator.exe 
$env:Path += ";$env:JAVA_HOME\bin"
$env:Path += ";$env:ANDROID_HOME\emulator"
$env:Path += ";$env:ANDROID_HOME\platform-tools"

adb --version
java --version 
emulator -list-avds


function JITPACK_RUNNER()
{
    ##Remove-Item -Path "XYZ" -Recurse -Force
    if (Test-Path "app\build") { Remove-Item -Path "app\build" -Recurse -Force }
    if (Test-Path "mylibrary\build") { Remove-Item -Path "mylibrary\build" -Recurse -Force }

    .\gradlew clean
exit 

    .\gradlew build 
    .\gradlew --console=verbose publishToMavenLocal
    .\gradlew publish

    # ".\mylibrary\build\repo\com\spicy\mylibrary\1.0.0\"

#.\gradlew assembleRelease 

##  C:\Users\zvl_2\.m2\repository\com\spicy\mylibrary\1.0\mylibrary-1.0.pom
#.\gradlew --console=verbose publishToMavenLocal

    exit 

    .\gradlew assembleDebug
    if (Test-Path "app\build") {Get-ChildItem -Recurse -Filter *.apk "app\build\outputs\"  | Select-Object -ExpandProperty Name}
    if (Test-Path "mylibrary\build") {Get-ChildItem -Recurse -Filter *.aar "mylibrary\build\outputs\"  | Select-Object -ExpandProperty Name}

#    .\gradlew testDebug

    Write-Host "Done!"
    exit 
}
JITPACK_RUNNER


function module_log()
{
    clear
    #adb logcat *:E
    #adb logcat -s MyNativeModule:E
    adb logcat *:S ReactNative:V ReactNativeJS:E
    #adb logcat -s MyNativeModule

    exit 
}
#module_log


function ANDROID_COMPILE() 
{
    cd android
    #rm app\build\intermediates\javac\debug\compileDebugJavaWithJavac\classes\com\spicytech

    #./gradlew clean
    ./gradlew assembleDebug
    Get-ChildItem -Recurse -Filter *.class "app\build\intermediates\javac"  | Select-Object -ExpandProperty Name

    cd ..

    #module_log # ?? 
    exit 
}
#module_compile

function EXPO_THIRD_PART_SETUP()
{
    ## https://docs.expo.dev/modules/third-party-library/


}


function EXPO_DEVELOPER_SETUP()
{
    $PROJECT_NAME="ExpoTest6a"
    npx create-expo-app@latest $PROJECT_NAME 
    cd $PROJECT_NAME

    ## https://docs.expo.dev/tutorial/eas/configure-development-build/
    npx expo install expo-dev-client #create-expo-module  

    ## https://docs.expo.dev/modules/get-started/
    npx create-expo-module@latest --local 

    ## app -> app-example 
    npm run reset-project 
    
    mv app\index.tsx app\index.js

    ls modules\my-module\src\MyModule.ts 
    ls modules\my-module\android\src\main\java\expo\modules\mymodule\MyModule.kt 

    exit 
}


function EXPO_RUNNER_2()
{
    ## SEE: 
    ##  How to wrap native libraries | Expo modules tutorial
    ##  https://docs.expo.dev/modules/third-party-library/
    ## 
    #EXPO_DEVELOPER_SETUP # ) 

    #ANDROID_COMPILE ## ) 

    ## Next line allows to build and re-load the application to the "device"
    ## try -> --device
    
    ## First time ... (Android Bundled...; Bridgeless mode is enabled...;)
    #npx expo run:android --port  8081 # :) 

    ## Then (modify 'modules\my-module\android\src\main\java\expo\modules\mymodule\MyModule.kt' ) 
    ## This should finish but the previuos one mush be still running...
    echo 'n' | npx expo run:android --port  8081 # :) 

## ...
## > Configure project :app
## ...
## > Configure project :expo
## ...
## > Configure project :react-native-reanimated
## Android gradle plugin: 8.6.0
## Gradle: 8.10.2
## ...
## BUILD SUCCESSFUL in 12s
## ...
## Starting Metro Bundler
## ...
##› Installing F:\Download\Expo\ExpoTest4\android\app\build\outputs\apk\debug\app-debug.apk
##› Opening exp+expotest4://expo-development-client/?url=http%3A%2F%2F192.168.1.199%3A8081 on Medium_Phone_API_36      
##
##› Logs for your project will appear below. Press Ctrl+C to exit.
##Android Bundled 911ms node_modules\expo-router\entry.js (1028 modules)
## (NOBRIDGE) LOG  Bridgeless mode is enabled

## development server
#npm run reset-project
#npx expo start --clear --android ## interactive mode 


## ERRORs :
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1
#Restart-Computer

## https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell
#New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

# > Task :react-native-reanimated:buildCMakeDebug[arm64-v8a] FAILED
## npx expo install react-native-reanimated
## rm .\android\.gradle\

}
EXPO_RUNNER_2


function RUNNER_EXPO_1()
{
    ## The legacy expo-cli does not support Node +17.
    #npm install expo-cli -g 

    #npm install expo

    #npx expo --version # 0.22.26    
    
    ##emulator -avd Medium_Phone_API_36 -wipe-data ## crean
    #emulator -avd Medium_Phone_API_36 -no-snapshot-load

    npx expo start --android
} 
#RUNNER_EXPO_1


function RUNNER_DEVICE_1()
{
    $SERIAL_NUMBER="1090018024064335"
    adb devices

    adb -s $SERIAL_NUMBER install -r app-build.apk 
    adb -s $SERIAL_NUMBER shell monkey -p com.spicytech.test2 -c android.intent.category.LAUNCHER 1 

    echo "apk ok!"
}
RUNNER_DEVICE_1


function RUNNER_EMULATOR_1()
{
    #Start-Job { emulator -avd Medium_Phone_API_36 }
    #echo "emulator ok!"
    #exit 

    #aapt dump badging app-build.apk | grep package:\ name
    adb install -r app-build.apk
    adb shell monkey -p com.spicytech.test1 -c android.intent.category.LAUNCHER 1

    echo "apk ok!"
}
#RUNNER_EMULATOR_1




function CREATE()
{
    $TEST_NAME="A7A3"
    npm install react-native-tts
    npm install react-native-webview 
    
# npm install react-native-geolocation-service
# npm install @react-native-community/geolocation  

    npx @react-native-community/cli@latest init ${TEST_NAME}   
    cd ${TEST_NAME}  

    mv App.tsx App.js
    exit 
}
#CREATE

function RELEASE_CREATE()
{
    cd android 
    ./gradlew assembleRelease    

    adb install -r app/build/outputs/apk/release/app-release.apk

    #  .\app\build.gradle -> applicationId "com.a7a3"
    adb shell monkey -p com.a7a3 -c android.intent.category.LAUNCHER 1

    exit
}
#RELEASE_CREATE

function RUNNER_1() 
{
    adb kill-server
    adb start-server
    adb devices

    #npx react-native start --reset-cache 

    ##npx react-native run-android
    ##npx react-native run-android --device 
    npx react-native run-android --device 1090018024064335 --verbose

    ls .\android\app\build\outputs\apk\debug\app-debug.apk
}
#RUNNER_1



$env:Path = $originalPath


<#

# -no-snapshot-load | -no-snapshot-save | -wipe-data
#emulator -avd Medium_Phone_API_36 -no-snapshot-save 

#Read-Host "Remove USB..."
#emulator -avd Medium_Phone_API_36 -no-snapshot-load

#exit 
# Expo go!
#npx expo start --clear --android 
# exit

###& "D:\z2025_1\Downloads\Expo.Orbit-2.0.2-x64.Setup.exe"

#npx @react-native-community/cli@latest init Example6b1  
#cd Example6b1

#npx react-native start --reset-cache 

#npx react-native run-android


## cd android
## .\gradlew assembleDebug
#>

<#

https://github.com/react-native-community/cli

https://reactnative.dev/docs/getting-started-without-a-framework

https://microsoft.github.io/react-native-windows/docs/getting-started

https://dev.to/aneeqakhan/step-by-step-guide-running-your-first-react-native-android-app-in-2023-1hh6

#>

<#
EXPO : 

npm install create-expo-app

npx create-expo-app@latest MyApp3 

cd MyApp3

npm run web 
#>

<#
https://www.emqx.com/en/blog/how-to-use-mqtt-in-react-native

npm install react_native_mqtt  

npm install @rneui/base @rneui/themed
#>

<#

npx @react-native-community/cli@latest init Example3a1

## For react-native@>=0.78 and react@>=19, you need to use @shopify/react-native-skia@next
npm install @shopify/react-native-skia@next

yarn add @wuba/react-native-echarts echarts

#>

<#
adb tcpip 5555
Start-Sleep -Seconds 5

adb shell ip route

Read-Host "Remove USB... "

$ipRoute = adb shell ip route
if ($ipRoute -match 'src (\d{1,3}(\.\d{1,3}){3})') {
    $ip = $Matches[1]
    echo $ip 
    adb connect $ip
} else {
    Write-Host "IP address not found in route output."
}
#>

