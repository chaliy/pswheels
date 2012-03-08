PsWheels Utils
=============

Set of wheels for PowerShell, opinioated stuff that people probably need for every day.

Features
========

1. Replace text in all child files

Example
=======

To replace text in all child files with text1

    invoke-replace text text1


Installation
============

If you have <a href="https://github.com/chaliy/psget">PsGet</a> installed, you can execute:

    install-module PsWheels
    
Or manual steps

    1. Copy PsWheels.psm1 to your modules folder (e.g. $Env:PSModulePath\PsWheels\ )
    2. Execute Import-Module PsWheels (or add this command to your profile)
    3. Enjoy!