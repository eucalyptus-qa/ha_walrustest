#!/bin/bash

gcc ../prerun/runat.c -o runat
export PATH=.:$PATH
./component_controller.pl START WS BOTH reboot
./component_controller.pl START CLC BOTH reboot


sleep 30
