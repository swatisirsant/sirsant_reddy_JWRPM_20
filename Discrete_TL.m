function D1=Discrete_TL(d1)

%code to get discrete diameter values

dia=[25.4 50.8 76.2 101.6 152.4 203.2 254 304.8 355.6 406.4 457.2 508 558.8 609.6];
range=[25.4 50.8;50.8 76.2;76.2 101.6;101.6 152.4;152.4 203.2;203.2 254;254 304.8;304.8 355.6;355.6 406.4;406.4 457.2;457.2 508;508 558.8;558.8 609.6];
Dmax=609.6;
Dmin=25.4;
for i=1:8
    if d1(i)<Dmin
        D1(i)=Dmin;
    else if d1(i)>Dmax
            D1(i)=Dmax;
        else D1(i)=d1(i);
        end
    end
end
D1;
for i=1:8
    for k=1:13
        if D1(i)>=range(k,1) && D1(i)<=range(k,2)
              b=k;
              S(i)=b;
        end 
    end
S;
 
           if (D1(i)-range(S(i),1))>(range(S(i),2)-D1(i)) ;
               D1(i)=range(S(i),2);
           else D1(i)=range(S(i),1);
           end  
end
D1;
end