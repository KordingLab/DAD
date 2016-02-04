% plays random beep

f0 = 440;
fs = 8000;  
y=[]; 
for i=1:15 
    t = 0:1/fs:(0.1*randi(5,1)); 
    num = randi(300,1); 
    y = [y,  sin(2*pi*(f0+num).*t), zeros(1,randi(1000,1))]; 
end
p = audioplayer(y, fs); play(p)
