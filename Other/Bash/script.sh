# main.sh
# .sh - shell
#!/bin/bash
echo "whats is your name"
read name
echo "hello , $name! wellcome to bash"
sleep 1 
mkdir New && touch New/new.txt
echo "type first number"
read num1 
echo "type second number" 
read num2
echo "sum: $(($num1 + $num2))"


echo "Введите любое натуральное число:"
read number
if ((number > 10)); then
    echo "Число > 10"
elif ((number == 10)); then
    echo "Число = 10"
else
    echo "Число < 10"
fi
