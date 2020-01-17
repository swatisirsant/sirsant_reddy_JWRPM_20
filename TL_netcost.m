function netcost = TL_netcost(dia1)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% wdsfile='TL.inp';
% addpath('G:\matlab_codes\Epanet files');
% epanetloadfile(wdsfile);
ch = [25.4 50.8 76.2 101.6 152.4 203.2 254 304.8 355.6 406.4 457.2 508 558.8 609.6];    
cost=  [2 5 8 11 16 23 32 50 60 90 130 170 300 550];

cst =[];
for j=1:8
    for k=1:14
       if round(dia1(j)*1000)==round(ch(k)*1000);
            cst(j,1)=1000.*cost(k);
       end
    end
end
netcost=sum(cst,1);
% setdata('EN_DIAMETER',dia1);
% ENsolveH();
% head=getdata('EN_PRESSURE');
% for i=1:6
%     if head(i)<30
%         netcost=10^20;
% %     else
% %         DH(i)=0;
%     end
% end
% DHmax=max(DH);
% penalty=DHmax*(10^9);
% netcost=netcost+penalty;
% epanetclose();