import math
x_list=[10000, 10000, 10000, 10000, -10000]
y_list=[10000, 10000, 10000, 10000, 10000]
ang_list = [45, 90, 135, 225, 0]
A=1

for i in range(0,len(x_list)) :
        
    ang=ang_list[i]
    z0=math.radians(ang)
    z0_notrad=ang
    z0_int = ang_list[i]/45*32768
    xn=A*(x_list[i]*math.cos(z0)-y_list[i]*math.sin(z0))
    yn=A*(y_list[i]*math.cos(z0)+x_list[i]*math.sin(z0))

    print("X0: ",x_list[i], " Y0: ",x_list[i], " Z0: ", z0_int, "\n")
    print("Xn: ",xn, " Yn: ",yn,"\n")
    xn_vec=A*math.sqrt(x_list[i]**2+y_list[i]**2)
    zn_vec=(180/math.pi)*math.atan(y_list[i]/x_list[i])*32768/45
    print("Xn_vec: ",xn_vec, "Zn_vec: ",zn_vec)
    print("------", "\n")