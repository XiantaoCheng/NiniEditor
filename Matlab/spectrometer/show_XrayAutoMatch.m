%{
地址::Matlab\spectrometer\show_XrayAutoMatch.m
+[保存文本](,show_XrayAutoMatch)
%}



function show(cellx,Fn,Cell,shY,dy,IP,Fx,Fy,shadow)
    cellx1=cellx(Fn(:,2)==1);
    cellx2=cellx(Fn(:,2)==2);
    cellz1=Cell(1)*ones(size(cellx1));
    cellz2=Cell(1)*ones(size(cellx2));
    shx1=shY(Fn(:,2)==1)'-dy(1);
    shx2=shY(Fn(:,2)==2)'-dy(1);
    shz1=IP*ones(size(shx1));
    shz2=IP*ones(size(shx2));
    figure;
    plot(Fx,Fy,'bo',[shz1 cellz1]',[shx1 cellx1]','b',[shz2 cellz2]',[shx2 cellx2]','r');
    text(IP*ones(size(shY)),shY'-dy(1),num2str(shadow'));
end

