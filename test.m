a = [1, 9, 15, 17, 12, 3, 0];
b = RH_shift(a,2.3,10);

[~, xpeak] = max(a);

points = [a(xpeak-1), a(xpeak), a(xpeak+1)];
[a_parabola] = polyfit(xpeak-1:xpeak+1,points,2);
a_parabola = polyval(a_parabola,3:0.1:5)

[~, xpeak] = max(b);

points = [b(xpeak-1), b(xpeak), b(xpeak+1)];
[b_parabola] = polyfit(xpeak-1:xpeak+1,points,2);
b_parabola = polyval(b_parabola,5:0.1:7)

[~, max_a] = max(a_parabola);
max_a = max_a*0.1+3;
[~, max_b] = max(b_parabola);
max_b = max_b*0.1+5;

plot(a);
hold on;
plot(3:0.1:5,a_parabola);
hold on;
plot(5:0.1:7,b_parabola);
hold on;
plot(b);