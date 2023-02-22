#!/bin/bash
echo "should not work"
python_folder="./python_scripts"
echo $python_folder
python "${python_folder}/dumy.py"


echo "should work"
python_folder="python_scripts"
echo $python_folder
python "${python_folder}/dumy.py"

echo "turns out both cmds work in a virtual env but not without virtual env"


# output with virtuale env
##### 

# should not work
# ./python_scripts
# hello
# should work
# python_scripts
# hello
# turns out both cmds work in a virtual env but not without virtual env

# output without virtual env
### 

# should not work
# ./python_scripts
# ./dummy.sh: line 5: python: command not found
# should work
# python_scripts
# ./dummy.sh: line 11: python: command not found
# turns out both cmds work in a virtual env but not without virtual env