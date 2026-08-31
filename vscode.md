# vscode

## reference

```
https://robotcode.io/02_get_started/
```

## install vscode and RobotCode

```
install vscode
vscode -> Extensions, install the RobotCode - Robot Framework Support
```

## create a new folder

```
File > Open Folder, create a new folder
```

## create requirements.txt

```
Create a requirements.txt file in the root folder of your project and add the following content:
robotframework
robotframework-robocop
robotframework-browser
```

## virtual environment

```
1. 在vscode最上面中间的搜索框里选择Show and Run Commands: Ctrl + Shift + P, then search for Python: Create Environment, and select it.
2. Choose Venv, this will create a virtual environment in the .venv folder in your project.
3. Select your preferred Python version.
4. Check the box for requirements.txt and click OK.
```

## Verifying the Installation

```
1. Open the terminal in Visual Studio Code. You can do this by pressing CONTROL+` or selecting Terminal > New Terminal from the menu. 
If there is an existing terminal, you can close it and open a new one to ensure that the virtual environment is activated.
2. Run the command robot --version to check if Robot Framework is installed correctly.
```

## Create and Run Your First Suite/Test 

```
Create a first.robot file in your project with the following code to demonstrate a basic example of logging a string message to the debug console:
*** Test Cases ***
First Test Case
    Log    Hello world

To run this test file, press the green play button next to the First Test Case keyword in the code. 
You should see the Hello world output displayed in the Debug Console of Visual Studio Code.

And that's it! If you have any questions or run into issues, check out the RobotCode documentation or join our community in slack for support. Happy coding!

```
