#!/usr/bin/env octave -q
## catenary_no_EI.m
## octave script to calculate assymetric catenary line without elasticity  
## uniform weight per length - one type of cable

## input block - all units in meters and kg or use other consistent units
L=input ("Horizontal Distance between supports in meters: ");
S=input ("Hanging Cable length in meters - must be greater than distance between supports: ");
d=input ("Vertical Distance Between supports in meters: ");
w=input ("Unit Weight of Catenary line in kg/m: ");
za=input ("Elevation of higher support (A) from reference plane in meters: ");
## end of input block
## equation to calculate initial value of 'a'
## a*sinh(L/(2*a)+atanh(d/S))+a*sinh(L/(2*a)-atanh(d/S))-S=0
## 'a' to be solved by fzero
catFun=@(a) a*sinh(L/(2*a)+atanh(d/S))+a*sinh(L/(2*a)-atanh(d/S))-S;
  ## initial guess of a=0.0001
a=fzero(catFun, [-1, +180])
# hor. distance between lowest catenary point (P) to higher support point (La)
La=a*(L/(2*a)+atanh(d/S))
# hor. distance between lowest catenary point (P) to lower support point (Lb)
Lb=L-La
# vert. distance from higher support point to lowest point (P) in catenary (ha)
ha=a*cosh(La/a)-a
## calculating reaction forces and angles
# catenary lenght between support "A" (higher) and "P" - Sa
Sa=a*sinh(La/a)
# catenary lenght between support "B" )lower) and "P" - Sb
Sb=a*sinh(Lb/a)
# horizontal tension - constant through catenary: H
H=w*a
# vertical tension at "A"  (Va) and "B" (Vb)
Va=Sa*w
Vb=Sb*w
# tension at "A" (TA) and B (TB)
TA=(H.**2+Va.**2).**0.5
TB=(H.**2+Vb.**2).**0.5
# inclination angles from vertical at "A" (ThetA) and B (ThetB)
ThetA=atan(H/Va)
ThetB=atan(H/Vb)
ThetAd=ThetA*180/pi;
ThetBd=ThetB*180/pi;
# establishing A, B and P in coordinate system
# index "a" corresponding to point "A", "b" to "B"-point and "P" to lowest caten. point
zb=za-d
zp=za-ha
xa=La
xp=0
xb=-Lb
# graphing catenary curve - 100 points
xinc=L/100
x=xb:xinc:xa;
y=a*cosh(x/a);
plot (x, y)
axis ([xb, xa], "equal")  # equal scale for x- and y- axis
xlabel("Distance X")
ylabel("Distance Y")
title("Catenary Curve")
print ("Catenary.png", "-dpng")
print ("Catenary.dxf", "-ddxf")
#write results to file
fid=fopen("catenary_res.txt", "a");
fprintf (fid, "\nHorizontal Distance between supports in meters: %f", L);
fprintf (fid, "\nCatenary length in meters: %f", S);
fprintf (fid, "\nVertical Distance Between supports in meters: %f", d);
fprintf (fid, "\nUnit Weight of Catenary line in kg/m: %f", w);
fprintf (fid, "\nElevation of higher support (A) from reference plane in meters: %f", za);
fprintf (fid, "\nCatenary coef.: %f", a);
fprintf (fid, "\nHorizontal tension in kg (constant along line: %f", H);
fprintf (fid, "\nVertical tension in A in kg: %f", Va);
fprintf (fid, "\nTotal tension in A in kg: %f", TA);
fprintf (fid, "\nTotal tension in B in kg: %f", TB);
fprintf (fid, "\nInclination angles from vertical at A in radians: %f", ThetA);
fprintf (fid, "\nInclination angles from vertical at B in radians: %f", ThetB);
fprintf (fid, "\nInclination angles from vertical at A in degrees: %f", ThetAd);
fprintf (fid, "\nInclination angles from vertical at B in degrees: %f", ThetBd);
fclose(fid);
