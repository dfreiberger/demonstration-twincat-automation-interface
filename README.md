# Introduction
This project demonstrates a working PowerShell example for manipulating a TwinCAT project.

The PLC project in this case will just write to a text file.

The text file is a way to check whether the PLC project has completed a task. For example this might be used to collect Unit Test results output by [TcUnit](https://tcunit.org).

## Usage

From PowerShell

    .\Demo.ps1

## Explanation

In the [AutomationInterface manual](https://download.beckhoff.com/download/Document/automation/twincat3/AutomationInterface_pdf_EN.pdf) it describes how to use PowerShell to interact with VisualStudio and TwinCAT XAE.

This project is just a complete example that seems to work. The main thing to note is the use of the MessageFilter as described in section 4.2.5 "Implementing a COM Message Filter". If you don't implement this, you may find that the script does not wait for certain API calls to complete.
