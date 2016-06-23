// Emacs mode hint: -*- mode: JavaScript -*-
//
// Script used to install qt 5.6.0 on windows with mingw support in automatic
// mode, you call this as:
//
// $ QTINSTALLER --script <file>
//
// based on: http://stackoverflow.com/a/34032216
//

function Controller() {
    print("(print) Hello Installer World!\n");
    console.log("(console.log) Hello Installer World!\n");
    console.log("(console.log) Installing via puppet\n");

    installer.setDefaultPageVisible(QInstaller.Introduction, false);
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);

    var page = gui.pageWidgetByObjectName( "ComponentSelectionPage" );
    page.selectComponent( "com.msys2.root" );
    page.selectComponent( "com.msys2.root.base" );

    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
    installer.setDefaultPageVisible(QInstaller.LicenseCheck, false);
    installer.setDefaultPageVisible(QInstaller.ReadyForInstallation, false);
    installer.setDefaultPageVisible(QInstaller.PerformInstallation, false);
    installer.setDefaultPageVisible(QInstaller.InstallationFinished, false);
    installer.setDefaultPageVisible(QInstaller.FinishedPage, false);
    ComponentSelectionPage.selectAll();
    installer.autoRejectMessageBoxes();
    var result = QMessageBox.question("quit.question", "Installer", "Do you want to quit the installer?",
                                      QMessageBox.Yes | QMessageBox.No);

    console.log("(console.log) result " + result);
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);

    installer.setMessageBoxAutomaticAnswer("OverwriteTargetDirectory", QMessageBox.Yes);
    installer.setMessageBoxAutomaticAnswer("stopProcessesForUpdates", QMessageBox.Ignore);

    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();

    widget.selectAll();

    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
    checkBoxForm.launchQtCreatorCheckBox.checked = false;
}
    gui.clickButton(buttons.FinishButton);
}
