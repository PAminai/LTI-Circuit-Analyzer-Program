clear;close all;clc;format short;

% ********************* farakhani file txt ********************************

fid=fopen('D:\9532545_Pooya Aminai_CircuitProject2\Data.txt','r');
t=fgetl(fid); %fgetL : Read line from file, removing newline characters
while t~=-1 % ta zamani ke line jadid tareef shode bashe
    class='';
    for j=1:numel(t) % numel(t)= tedade character haee ke tooye ye line vogud dare. number or string
        class=[class,'%f']; % just numbers (fractional), be tedad numbers haye dakhele oon line %f mizarim .
    end
    
    if strfind(t,'R') %read conductance from .txt file
        
        r=sscanf(t,['R' ,class ]);%scan line ba format delkhah, masalan inja ba formate %f%f%f%f...
        r=r'; % ta inja oomadim tamame numbers haye dakhele line ro dar avordim
        n=numel(r);
        R=[];
        for i=1:3:n %miad 3ta3ta tooye ye satr az matrix mizare.
            R=[R;r(i:i+2)];
        end
    elseif strfind(t,'C') %read capasitance from .txt file
        c=sscanf(t,['C' ,class]);
        c=c';
        n=numel(c);
        C=[];
        for i=1:4:n
            C=[C;c(i:i+3)];
        end
    elseif strfind(t,'L') %read inductance from .txt file
        l=sscanf(t,['L' ,class]);
        l=l';
        n=numel(l);
        L=[];
        for i=1:4:n
            L=[L;l(i:i+3)];
        end
    elseif strfind(t,'V') %read indipendent voltage source from .txt file
        
        j=sscanf(t,['V' ,class]);
        j=j';
        n=numel(j);
        S=[];
        for i=1:6:n
            S=[S;j(i:i+5)];
        end
        n=size(S);
        n=(n(1));
        V=[];
        for i=1:n
            
            Am=S(i,1);
            w=S(i,2);
            phi=S(i,3);
            phi=deg2rad(phi);
            d=S(i,4);
            syms t
            f=Am*cos(w*t+phi)+d;
            V=[V;f S(i,5) S(i,6)];
        end
    elseif strfind(t,'I') %read indipendent current source from .txt file
        
        j=sscanf(t,['I' ,class]);
        j=j';
        n=numel(j);
        S=[];
        for i=1:6:n
            S=[S;j(i:i+5)];
        end
        n=size(S);
        n=(n(1));
        I=[];
        for i=1:n
            Am=S(i,1); %Amplitude of ac source
            w=S(i,2); %omega
            phi=S(i,3);
            phi=deg2rad(phi);
            d=S(i,4);
            syms t
            f=Am*cos(w*t+phi)+d;
            I=[I;f S(i,5) S(i,6)];
        end
    elseif strfind(t,'A') %manba jaryane vabaste be voltage
        
        a=sscanf(t,['A' ,class]);
        a=a';
        n=numel(a);
        A=[];
        for i=1:5:n
            A=[A;a(i:i+4)];
        end
        
    elseif strfind(t,'B') %manba voltage vabaste be voltage
        b=sscanf(t,['B' ,class]);
        b=b';
        n=numel(b);
        B=[];
        for i=1:5:n
            B=[B;b(i:i+4)];
        end
        
    elseif strfind(t,'D') %manba jaryane vabaste be jaryan
        d=sscanf(t,['D' ,class]);
        d=d';
        n=numel(d);
        D=[];
        for i=1:5:n
            D=[D;d(i:i+4)];
        end
        
    elseif strfind(t,'F') %manba voltage vabaste be jaryan
        f=sscanf(t,['F' ,class]);
        f=f';
        n=numel(f);
        F=[];
        for i=1:5:n
            F=[F;f(i:i+4)];
        end
        
        
    elseif strfind(t,'M') % Coupling Elements
        m=sscanf(t,['M' ,class]);
        m=m';
        n=numel(m);
        M=[];
        for i=1:7:n
            M=[M;m(i:i+6)];
        end
        
    elseif strfind(t,'N') %Network function
        N=[str2num(t(5)) str2num(t(7)) str2num(t(12)) str2num(t(14))];
        K=[t(3) t(10)];
        
        
    elseif strfind(t,'O') % Output (khorooji dekhah e karbar)
        O=[str2num(t(3:13))];
        
        
    end
    
    
    
    
    t=fgetl(fid);
end

fclose(fid);
Y=[]; % matrix admitance
Y=sym(Y);
J=[];
J1=[];% for zero state ...
J=sym(J);
J1=sym(J1);

% ********************** por kardane matrix admitance ba G ****************
if exist('R','var')
    s=size(R);
    s1=s(1); % satr ha
    for i=1:s1 % morattab kardan az koochek be bozorg...
        if R(i,2)>R(i,3)
            m=R(i,2);
            R(i,2)=R(i,3);
            R(i,3)=m;
        end
    end
    R(:,1)=R(:,1).^(-1);
    G=R;
    for i=1:s1
        n=size(Y);
        n1=n(1); % tedade satr haye Y
        if G(i,2)~=0
            if G(i,2)<=n1
                Y(G(i,2),G(i,2))=Y(G(i,2),G(i,2))+G(i,1);
                J(G(i,2),1)=0;
                J1(G(i,2),1)=0;
                
            else
                Y(G(i,2),G(i,2))=+G(i,1);
                J(G(i,2),1)=0;
                J1(G(i,2),1)=0;
            end
            
            if G(i,3)<=n1
                Y(G(i,3),G(i,3))=Y(G(i,3),G(i,3))+G(i,1);
                J(G(i,3),1)=0;
                J1(G(i,3),1)=0;
            else
                Y(G(i,3),G(i,3))=+G(i,1);
                J(G(i,3),1)=0;
                J1(G(i,3),1)=0;
            end
            
            if G(i,3)&&G(i,2)<=n1
                Y(G(i,2),G(i,3))=Y(G(i,2),G(i,3))-G(i,1);
                Y(G(i,3),G(i,2))=Y(G(i,3),G(i,2))-G(i,1);
            else
                Y(G(i,3),G(i,2))=-G(i,1);
                Y(G(i,2),G(i,3))=-G(i,1);
            end
        end
        % age yeki az node ha zamin bashe.... 0=GND
        if G(i,2)==0
            if G(i,3)<=n1
                Y(G(i,3),G(i,3))=Y(G(i,3),G(i,3))+G(i,1);
                J(G(i,3),1)=0;
                J1(G(i,3),1)=0;
            else
                Y(G(i,3),G(i,3))=+G(i,1);
                J(G(i,3),1)=0;
                J1(G(i,3),1)=0;
            end
        end
        
    end
    
end

% ************** por kardane matrix admitance ba A ****************
% A = manba jaryane vabaste be voltage
if exist('A','var')
    
    s=size(A);
    s1=s(1); % satr ha ( tedaade manabe jaryane vabaste be voltage )
    for i=1:s1
        n=size(Y);
        n1=n(1); % tedade satr haye Y
        
        if A(i,2:5)~=0
            if A(i,2)<=n1  &&  A(i,4)<=n1
                Y(A(i,2),A(i,4))=Y(A(i,2),A(i,4))+A(i,1);
                J(A(i,2),1)=0;
                J1(G(i,3),1)=0;
            else
                Y(A(i,2),A(i,4))=+A(i,1);
                J(A(i,2),1)=0;
                J1(A(i,2),1)=0;
            end
            
            
            if A(i,2)<=n1  &&  A(i,5)<=n1
                Y(A(i,2),A(i,5))=Y(A(i,2),A(i,5))-A(i,1);
                J(A(i,2),1)=0;
                J1(A(i,2),1)=0;
            else
                Y(A(i,2),A(i,5))=-A(i,1);
                J(A(i,2),1)=0;
                J1(A(i,2),1)=0;
            end
            
            
            if A(i,3)<=n1  &&  A(i,4)<=n1
                Y(A(i,3),A(i,4))=Y(A(i,3),A(i,4))-A(i,1);
                J(A(i,3),1)=0;
            else
                Y(A(i,3),A(i,4))=-A(i,1);
                J(A(i,3),1)=0;
                J1(A(i,3),1)=0;
            end
            
            
            
            if A(i,3)<=n1  &&  A(i,5)<=n1
                Y(A(i,3),A(i,5))=Y(A(i,3),A(i,5))+A(i,1);
                J(A(i,3),1)=0;
                J1(A(i,3),1)=0;
            else
                Y(A(i,3),A(i,5))=+A(i,1);
                J(A(i,3),1)=0;
                J1(A(i,3),1)=0;
            end
        end
        
        % hala age yeki az node ha zamin bashe . . .
        
        if A(i,2)==0 && A(i,3)~=0
            if A(i,4)~=0 && A(i,5)~=0
                if A(i,3)<=n1  &&  A(i,4)<=n1
                    Y(A(i,3),A(i,4))=Y(A(i,3),A(i,4))-A(i,1);
                    J(A(i,3),1)=0;
                    J1(A(i,3),1)=0;
                else
                    Y(A(i,3),A(i,4))=-A(i,1);
                    J(A(i,3),1)=0;
                    J1(A(i,3),1)=0;
                end
                
                if A(i,3)<=n1  &&  A(i,5)<=n1
                    Y(A(i,3),A(i,5))=Y(A(i,3),A(i,5))+A(i,1);
                    J(A(i,3),1)=0;
                else
                    Y(A(i,3),A(i,5))=+A(i,1);
                    J(A(i,3),1)=0;
                    J1(A(i,3),1)=0;
                end
            end
            if A(i,4)~=0 && A(i,5)==0
                if A(i,3)<=n1  &&  A(i,4)<=n1
                    Y(A(i,3),A(i,4))=Y(A(i,3),A(i,4))-A(i,1);
                    J(A(i,3),1)=0;
                    J1(A(i,3),1)=0;
                else
                    Y(A(i,3),A(i,4))=-A(i,1);
                    J(A(i,3),1)=0;
                    J1(A(i,3),1)=0;
                end
            end
            if A(i,4)==0 && A(i,5)~=0
                if A(i,3)<=n1  &&  A(i,5)<=n1
                    Y(A(i,3),A(i,5))=Y(A(i,3),A(i,5))-A(i,1);
                    J(A(i,3),1)=0;
                    J1(A(i,3),1)=0;
                else
                    Y(A(i,3),A(i,5))=-A(i,1);
                    J(A(i,3),1)=0;
                    J1(A(i,3),1)=0;
                end
            end
        end
        if A(i,2)~=0 && A(i,3)==0
            if A(i,4)~=0 && A(i,5)~=0
                if A(i,2)<=n1  &&  A(i,4)<=n1
                    Y(A(i,2),A(i,4))=Y(A(i,2),A(i,4))+A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                else
                    Y(A(i,2),A(i,4))=+A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                end
                
                if A(i,2)<=n1  &&  A(i,5)<=n1
                    Y(A(i,2),A(i,5))=Y(A(i,2),A(i,5))-A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                else
                    Y(A(i,2),A(i,5))=-A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                end
            end
            if A(i,4)~=0 && A(i,5)==0
                if A(i,2)<=n1  &&  A(i,4)<=n1
                    Y(A(i,2),A(i,4))=Y(A(i,2),A(i,4))+A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                else
                    Y(A(i,2),A(i,4))=+A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                end
            end
            if A(i,4)==0 && A(i,5)~=0
                if A(i,2)<=n1  &&  A(i,5)<=n1
                    Y(A(i,2),A(i,5))=Y(A(i,2),A(i,5))-A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                else
                    Y(A(i,2),A(i,5))=-A(i,1);
                    J(A(i,2),1)=0;
                    J1(A(i,2),1)=0;
                end
            end
        end
        
    end
    
end

% ********************  por kardane I ha ba current source ***********************
syms s
if exist('I','var')
    
    s=size(I);
    s1=s(1);% satr ha
    
    I(:,1)=laplace(I(:,1));
    
    for i=1:s1
        
        if I(i,2)~=0 && I(i,3)~=0
            if I(i,2)<=numel(J);% ooni ke behesh vared mishe
                J(I(i,2))=J(I(i,2))+I(i,1);
                J1(I(i,2))=J1(I(i,2))+I(i,1);
                
            else
                J(I(i,2))=I(i,1);
                J1(I(i,2))=I(i,1);
                
            end
            if I(i,3)<=numel(J);% ooni ke azash kharej mishe
                J(I(i,3))=J(I(i,3))-I(i,1);
                J1(I(i,3))=J1(I(i,3))-I(i,1);
            else
                J(I(i,3))=-I(i,1);
                J1(I(i,3))=-I(i,1);
            end
        end
        
        
        if I(i,2)==0 && I(i,3)~=0
            if I(i,3)<=numel(J);
                J(I(i,3))=J(I(i,3))-I(i,1);
                J1(I(i,3))=J1(I(i,3))-I(i,1);
                
            else
                J(I(i,3))=-I(i,1);
                J1(I(i,3))=-I(i,1);
            end
        end
        
        if I(i,2)~=0 && I(i,3)==0
            if I(i,2)<=numel(J);
                J(I(i,2))=J(I(i,2))+I(i,1);
                J1(I(i,2))=J1(I(i,2))+I(i,1);
                
            else
                J(I(i,2))=+I(i,1);
                J1(I(i,2))=+I(i,1);
            end
        end
    end
end

% ********************** por kardane matrix admitance ba C ****************
if exist('C','var')
    
    s=size(C);
    s1=s(1); % satr ha (tedade khazan ha)
    syms s
    for i=1:s1
        
        n=size(Y);
        n1=n(1); % tedade satr haye Y
        if C(i,2)~=0 && C(i,3)~=0
            if C(i,2)<=n1
                Y(C(i,2),C(i,2))=Y(C(i,2),C(i,2))+C(i,1)*s;
                
            else
                Y(C(i,2),C(i,2))=+C(i,1)*s;
            end
            
            if C(i,3)<=n1
                Y(C(i,3),C(i,3))=Y(C(i,3),C(i,3))+C(i,1)*s;
            else
                Y(C(i,3),C(i,3))=+C(i,1)*s;
            end
            
            if C(i,3)&&C(i,2)<=n1
                Y(C(i,2),C(i,3))=Y(C(i,2),C(i,3))-C(i,1)*s;
                Y(C(i,3),C(i,2))=Y(C(i,3),C(i,2))-C(i,1)*s;
            else
                Y(C(i,3),C(i,2))=-C(i,1)*s;
                Y(C(i,2),C(i,3))=-C(i,1)*s;
            end
        end
        % age yeki az node ha zamin bashe.... 0=GND
        if C(i,2)==0
            if C(i,3)<=n1
                Y(C(i,3),C(i,3))=Y(C(i,3),C(i,3))+C(i,1)*s;
            else
                Y(C(i,3),C(i,3))=+C(i,1)*s;
            end
        end
        if C(i,3)==0
            if C(i,2)<=n1
                Y(C(i,2),C(i,2))=Y(C(i,2),C(i,2))+C(i,1)*s;
            else
                Y(C(i,2),C(i,2))=+C(i,1)*s;
            end
        end
        
    end
    
    
end


% ********************  por kardane J ha ba sharayet avalie khazan ***********************
if exist('C','var')
    s=size(C);
    s1=s(1);% satr ha(tedade khazan ha. . .)
    syms s
    for i=1:s1
        
        if C(i,2)~=0 && C(i,3)~=0
            
            if C(i,2)<=numel(J);% sare +
                
                J(C(i,2),1)=J(C(i,2),1)+C(i,1)*C(i,4);
                J1(C(i,2),1)=J1(C(i,2),1)+0;% 0: zero state ...
                
            else
                J(C(i,2),1)=+C(i,1)*C(i,4);
                J1(C(i,2),1)=0;
                
            end
            if C(i,3)<=numel(J);% sare -
                J(C(i,3),1)=J(C(i,3),1)-C(i,1)*C(i,4);
                J1(C(i,3),1)=J1(C(i,3),1)-0;
                
            else
                J(C(i,3),1)=-C(i,1)*C(i,4);
                J1(C(i,3),1)=0;
            end
        end
        %Age yeki az saraye khazan zamin bashe
        if C(i,2)==0 && C(i,3)~=0
            if C(i,3)<=numel(J);
                J(C(i,3),1)=J(C(i,3),1)-C(i,1)*C(i,4);
                J1(C(i,3),1)=J1(C(i,3),1)-0;
                
            else
                J(C(i,3),1)=-C(i,1)*C(i,4);
                J1(C(i,3),1)=0;
            end
        end
        
        if C(i,2)~=0 && C(i,3)==0
            if C(i,2)<=numel(J);
                J(C(i,2))=J(C(i,2))+C(i,1)*C(i,4);
                J1(C(i,2))=J1(C(i,2))+0;
                
            else
                J(C(i,2),1)=+C(i,1)*C(i,4);
                J1(C(i,2),1)=0;
            end
        end
    end
end

% ********************  por kardane matrix admitance ba V ***********************
% mostaghel
if exist('V','var')
    
    s=size(V);
    s1=s(1); % tedade satr ha (tedade voltage source ha )
    s2=s(2); % tedade sotoon ha
    n=size(Y);
    n=n(1); % tedade satr va sotoon haye Y
    
    
    
    syms s
    v1=laplace(V(:,1)); % voltage source ha
    J=[J;v1];
    J1=[J1;v1];
    
    for i=1:s1
        
        if V(i,2)~=0 && V(i,3)~=0 % age ye saresh be zamin vasl nabshe
            
            Y(n+i,V(i,2))=1;
            Y(n+i,V(i,3))=-1;
            
            
            Y(V(i,2),n+i)=1;
            Y(V(i,3),n+i)=-1;
            
            % age yeki az sar hash be zamin vasl bashe . . .
            
        elseif V(i,2)==0 && V(i,3)~=0
            
            Y(n+i,V(i,3))=-1;
            Y(V(i,3),n+i)=-1;
            
        elseif V(i,2)~=0 && V(i,3)==0
            Y(n+i,V(i,2))=1;
            Y(V(i,2),n+i)=1;
            
        end
    end
    
end



% ********************  por kardane L ha ***********************
if exist('L','var')
    s=size(L);
    s1=s(1); % tedade satr ha (tedade self ha )
    s2=s(2); % tedade sotoon ha
    n=size(Y);
    n=n(1); % tedade satr va sotoon haye Y
    syms s
    for i=1:s1
        
        J=[J;-L(i,1)*L(i,4)]; % sharayete avvalie (oon tarafe tasavi)
        J1=[J1;0]; % zero state ...
        
        if L(i,2)~=0 && L(i,3)~=0 % age hich saresh be zamin vasl nabshe
            
            Y(n+i,L(i,2))=1;
            Y(n+i,L(i,3))=-1;
            
            
            Y(L(i,2),n+i)=1;
            Y(L(i,3),n+i)=-1;
            
            Y(n+i,n+i)=-s*L(i,1);
            J(n+i)=-L(i,1)*L(i,4);
            J1(n+i)=0;% zero state ...
            
            % age yeki az sar hash be zamin vasl bashe . . .
        elseif L(i,2)==0 && L(i,3)~=0
            
            Y(n+i,L(i,3))=-1;
            Y(L(i,3),n+i)=-1;
            Y(n+i,n+i)=-s*L(i,1);
            J(n+i)=-L(i,1)*L(i,4);
            J1(n+i)=0;
        elseif L(i,2)~=0 && L(i,3)==0
            
            Y(n+i,L(i,2))=1;
            Y(L(i,2),n+i)=1;
            Y(n+i,n+i)=-s*L(i,1);
            J(n+i)=-L(i,1)*L(i,4);
            J1(n+i)=0;
        end
        
    end
end

% ********************  por kardane matrix admitance ba B ***********************
% B = manba volate vabaste be voltage
if exist('B','var')
    s=size(B);
    s1=s(1); % tedade satr ha (tedade voltage source ha )
    s2=s(2); % tedade sotoon ha
    n=size(Y);
    n=n(1); % tedade satr va sotoon haye Y
    
    syms s
    B1=zeros(s1,1); % voltage source ha
    
    J=[J;B1];
    J1=[J1;B1];
    
    for i=1:s1
        if B(i,2:5)~=0 % age hich saresh be zamin vasl nabshe
            Y(n+i,B(i,2))=1;
            Y(n+i,B(i,3))=-1;
            Y(B(i,2),n+i)=1;
            Y(B(i,3),n+i)=-1;
            Y(n+i,B(i,4))=Y(n+i,B(i,4))-B(i,1);
            Y(n+i,B(i,5))=Y(n+i,B(i,5))+B(i,1);
            
        end
        %age ye saresh be zamin vasl bashe . . .
        if B(i,2)==0 && B(i,3)~=0
            if B(i,4)~=0 && B(i,5)~=0
                Y(n+i,B(i,3))=-1;
                Y(B(i,3),n+i)=-1;
                Y(n+i,B(i,4))=Y(n+i,B(i,4))-B(i,1);
                Y(n+i,B(i,5))=Y(n+i,B(i,5))+B(i,1);
            elseif B(i,4)==0 && B(i,5)~=0
                Y(n+i,B(i,3))=-1;
                Y(B(i,3),n+i)=-1;
                Y(n+i,B(i,5))=Y(n+i,B(i,5))+B(i,1);
            elseif B(i,4)~=0 && B(i,5)==0
                Y(n+i,B(i,3))=-1;
                Y(B(i,3),n+i)=-1;
                Y(n+i,B(i,4))=Y(n+i,B(i,4))+B(i,1);
            end
        elseif B(i,2)~=0 && B(i,3)==0
            if B(i,4)~=0 && B(i,5)~=0
                Y(n+i,B(i,2))=1;
                Y(B(i,2),n+i)=1;
                Y(n+i,B(i,4))=Y(n+i,B(i,4))-B(i,1);
                Y(n+i,B(i,5))=Y(n+i,B(i,5))+B(i,1);
            elseif B(i,4)==0 && B(i,5)~=0
                Y(n+i,B(i,2))=1;
                Y(B(i,2),n+i)=1;
                Y(n+i,B(i,5))=Y(n+i,B(i,5))+B(i,1);
            elseif B(i,4)~=0 && B(i,5)==0
                Y(n+i,B(i,2))=1;
                Y(B(i,2),n+i)=1;
                Y(n+i,B(i,4))=Y(n+i,B(i,4))+B(i,1);
            end
        elseif B(i,2)~=0 && B(i,3)~=0
            if B(i,4)==0 && B(i,5)~=0
                Y(n+i,B(i,2))=1;
                Y(B(i,2),n+i)=1;
                Y(n+i,B(i,5))=Y(n+i,B(i,5))+B(i,1);
            elseif B(i,4)~=0 && B(i,5)==0
                Y(n+i,B(i,2))=1;
                Y(B(i,2),n+i)=1;
                Y(n+i,B(i,4))=Y(n+i,B(i,4))+B(i,1);
            end
        end
    end
end

% ********************  por kardane matrix admitance ba D ***********************
% D = Current source vabaste be jaryan . . .
if exist('D','var')
    s=size(D);
    s1=s(1); % tedade satr ha (tedade Current source haye vabaste )
    s2=s(2); % tedade sotoon ha
    n=size(Y);
    n=n(1); % tedade satr va sotoon haye Y
    syms s
    D1=zeros(s1,1); % current source ha
    
    J=[J;D1]; % dorost kardane oon tarafe tasavi ...
    J1=[J1;D1];
    for i=1:s1
        if D(i,2:5)~=0 % age hich saresh be zamin vasl nabshe
            
            Y(n+i,D(i,4))=1;
            Y(n+i,D(i,5))=-1;
            Y(D(i,4),n+i)=1;
            Y(D(i,5),n+i)=-1;
            Y(D(i,2),n+i)=D(i,1)+Y(D(i,2),n+i);
            Y(D(i,3),n+i)=-D(i,1)+Y(D(i,3),n+i);
            
            
            
        end
        %age ye saresh be zamin vasl bashe . . .
        if D(i,2)==0 && D(i,3)~=0
            if D(i,4)~=0 && D(i,5)~=0
                Y(n+i,D(i,4))=1;
                Y(n+i,D(i,5))=-1;
                Y(D(i,4),n+i)=1;
                Y(D(i,5),n+i)=-1;
                Y(D(i,3),n+i)=Y(D(i,3),n+i)-D(i,3);
                
            elseif D(i,4)==0 && D(i,5)~=0
                Y(n+i,D(i,5))=-1;
                Y(D(i,5),n+i)=-1;
                Y(D(i,3),n+i)=Y(D(i,3),n+i)-D(i,3);
            elseif D(i,4)~=0 && D(i,5)==0
                Y(n+i,D(i,4))=1;
                Y(D(i,4),n+i)=1;
                Y(D(i,3),n+i)=Y(D(i,3),n+i)-D(i,3);
            end
        elseif D(i,2)~=0 && D(i,3)==0
            if D(i,4)~=0 && D(i,5)~=0
                Y(n+i,D(i,4))=1;
                Y(n+i,D(i,5))=-1;
                Y(D(i,4),n+i)=1;
                Y(D(i,5),n+i)=-1;
                Y(D(i,2),n+i)=Y(D(i,2),n+i)+D(i,2);
            elseif D(i,4)==0 && D(i,5)~=0
                Y(n+i,D(i,5))=-1;
                Y(D(i,5),n+i)=-1;
                Y(D(i,2),n+i)=Y(D(i,2),n+i)+D(i,2);
            elseif D(i,4)~=0 && D(i,5)==0
                Y(n+i,D(i,4))=1;
                Y(D(i,4),n+i)=1;
                Y(D(i,2),n+i)=Y(D(i,2),n+i)+D(i,2);
            end
            
        elseif D(i,2)~=0 && D(i,3)~=0
            if D(i,4)==0 && D(i,5)~=0
                Y(n+i,D(i,5))=-1;
                Y(D(i,5),n+i)=-1;
                Y(D(i,2),n+i)=Y(D(i,2),n+i)+D(i,1);
                Y(D(i,3),n+i)=Y(D(i,3),n+i)-D(i,1);
            elseif D(i,4)~=0 && D(i,5)==0
                Y(n+i,D(i,4))=1;
                Y(D(i,4),n+i)=1;
                Y(D(i,2),n+i)=Y(D(i,2),n+i)+D(i,1);
                Y(D(i,3),n+i)=Y(D(i,3),n+i)-D(i,1);
            end
        end
        
    end
end
% ********************  por kardane matrix admitance ba F ***********************
% F = Current source vabaste be jaryan . . .
if exist('F','var')
    
    s=size(F);
    s1=s(1); % tedade satr ha (tedade voltage source haye vabaste )
    s2=s(2); % tedade sotoon ha
    n=size(Y);
    n=n(1); % tedade satr va sotoon haye Y
    syms s
    F1=zeros(2*s1,1); % 2*s1==> chon be ezaye harkodoom 2 ta satr o sotoon ezafe mishe
    
    J=[J;F1]; % dorost kardane oon tarafe tasavi ...
    J1=[J1;F1];
    for i=1:s1
        
        if F(i,2:5)~=0 % age hich saresh be zamin vasl nabshe
            Y(n+i,F(i,4))=1;
            Y(n+i,F(i,5))=-1;
            Y(n+i+1,F(i,2))=1;
            Y(n+i+1,F(i,3))=-1;
            Y(n+i+1,n+i)=-F(i,1);
            
            Y(F(i,4),n+i)=1;
            Y(F(i,5),n+i)=-1;
            Y(F(i,2),n+i+1)=1;
            Y(F(i,3),n+i+1)=-1;
            
        end
        %age ye saresh be zamin vasl bashe . . .
        if F(i,2)==0 && F(i,3)~=0
            if F(i,4)~=0 && F(i,5)~=0
                Y(n+i,F(i,4))=1;
                Y(n+i,F(i,5))=-1;
                
                Y(n+i+1,F(i,3))=-1;
                Y(n+i+1,n+i)=-F(i,1);
                
                Y(F(i,4),n+i)=1;
                Y(F(i,5),n+i)=-1;
                
                Y(F(i,3),n+i+1)=-1;
                
                
            elseif F(i,4)==0 && F(i,5)~=0
                
                Y(n+i,F(i,5))=-1;
                
                Y(n+i+1,F(i,3))=-1;
                Y(n+i+1,n+i)=-F(i,1);
                
                
                Y(F(i,5),n+i)=-1;
                
                Y(F(i,3),n+i+1)=-1;
            elseif F(i,4)~=0 && F(i,5)==0
                Y(n+i,F(i,4))=1;
                
                
                Y(n+i+1,F(i,3))=-1;
                Y(n+i+1,n+i)=-F(i,1);
                
                Y(F(i,4),n+i)=1;
                
                
                Y(F(i,3),n+i+1)=-1;
            end
            
            
            
        elseif F(i,2)~=0 && F(i,3)==0
            if F(i,4)~=0 && F(i,5)~=0
                
                Y(n+i,F(i,4))=1;
                Y(n+i,F(i,5))=-1;
                Y(n+i+1,F(i,2))=1;
                
                Y(n+i+1,n+i)=-F(i,1);
                
                Y(F(i,4),n+i)=1;
                Y(F(i,5),n+i)=-1;
                Y(F(i,2),n+i+1)=1;
                
                
                
            elseif F(i,4)==0 && F(i,5)~=0
                
                Y(n+i,F(i,5))=-1;
                Y(n+i+1,F(i,2))=1;
                
                Y(n+i+1,n+i)=-F(i,1);
                
                
                Y(F(i,5),n+i)=-1;
                Y(F(i,2),n+i+1)=1;
            elseif F(i,4)~=0 && F(i,5)==0
                Y(n+i,F(i,4))=1;
                
                Y(n+i+1,F(i,2))=1;
                
                Y(n+i+1,n+i)=-F(i,1);
                
                Y(F(i,4),n+i)=1;
                
                Y(F(i,2),n+i+1)=1;
            end
            
            
        elseif F(i,2)~=0 && F(i,3)~=0
            if F(i,4)==0 && F(i,5)~=0
                
                Y(n+i,F(i,5))=-1;
                Y(n+i+1,F(i,2))=1;
                Y(n+i+1,F(i,3))=-1;
                Y(n+i+1,n+i)=-F(i,1);
                
                
                Y(F(i,5),n+i)=-1;
                Y(F(i,2),n+i+1)=1;
                Y(F(i,3),n+i+1)=-1;
            elseif F(i,4)~=0 && F(i,5)==0
                Y(n+i,F(i,4))=1;
                
                Y(n+i+1,F(i,2))=1;
                Y(n+i+1,F(i,3))=-1;
                Y(n+i+1,n+i)=-F(i,1);
                
                Y(F(i,4),n+i)=1;
                
                Y(F(i,2),n+i+1)=1;
                Y(F(i,3),n+i+1)=-1;
            end
        end
    end
end
% ********************  por kardane matrix admitance ba M ***********************
% M = selfe Tazvig (coupling elements ...)
if exist('M','var')
    s=size(M);
    s1=s(1); % tedade satr ha
    s2=s(2); % tedade sotoon ha
    n=size(Y);
    n=n(1); % tedade satr va sotoon haye Y
    syms s
    M1=zeros(2*s1,1); % 2*s1==> chon be ezaye harkodoom 2 ta satr o sotoon ezafe mishe
    J=[J;M1]; % dorost kardane oon tarafe tasavi ...
    J1=[J1;M1];
    for i=1:s1
        if M(i,4:7)~=0 % age hich saresh be zamin vasl nabshe
            Y(n+i,M(i,4))=1;
            Y(n+i,M(i,5))=-1;
            Y(n+i+1,M(i,6))=1;
            Y(n+i+1,M(i,7))=-1;
            
            Y(n+i,n+i)=-s*M(i,2);
            Y(n+i,n+i+1)=-s*M(i,1);
            Y(n+i+1,n+i)=-s*M(i,1);
            Y(n+i+1,n+i+1)=-s*M(i,3);
            
            Y(M(i,4),n+i)=1;
            Y(M(i,5),n+i)=-1;
            Y(M(i,6),n+i+1)=1;
            Y(M(i,7),n+i+1)=-1;
            
        end
        
        if M(i,4)==0 && M(i,5)~=0
            if M(i,6)~=0 && M(i,7)~=0
                
                Y(n+i,M(i,5))=-1;
                Y(n+i+1,M(i,6))=1;
                Y(n+i+1,M(i,7))=-1;
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                
                Y(M(i,5),n+i)=-1;
                Y(M(i,6),n+i+1)=1;
                Y(M(i,7),n+i+1)=-1;
                
            elseif M(i,6)==0 && M(i,7)~=0
                
                Y(n+i,M(i,5))=-1;
                
                Y(n+i+1,M(i,7))=-1;
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                
                Y(M(i,5),n+i)=-1;
                
                Y(M(i,7),n+i+1)=-1;
                
            elseif M(i,6)~=0 && M(i,7)==0
                
                Y(n+i,M(i,5))=-1;
                Y(n+i+1,M(i,6))=1;
                
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                
                Y(M(i,5),n+i)=-1;
                Y(M(i,6),n+i+1)=1;
                
                
            end
            
        elseif M(i,4)~=0 && M(i,5)==0
            if M(i,6)~=0 && M(i,7)~=0
                
                Y(n+i,M(i,4))=1;
                
                Y(n+i+1,M(i,6))=1;
                Y(n+i+1,M(i,7))=-1;
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                Y(M(i,4),n+i)=1;
                
                Y(M(i,6),n+i+1)=1;
                Y(M(i,7),n+i+1)=-1;
                
                
            elseif M(i,6)==0 && M(i,7)~=0
                
                Y(n+i,M(i,4))=1;
                
                
                Y(n+i+1,M(i,7))=-1;
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                Y(M(i,4),n+i)=1;
                
                
                Y(M(i,7),n+i+1)=-1;
                
                
            elseif M(i,6)~=0 && M(i,7)==0
                
                Y(n+i,M(i,4))=1;
                
                Y(n+i+1,M(i,6))=1;
                
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                Y(M(i,4),n+i)=1;
                
                Y(M(i,6),n+i+1)=1;
                
                
            end
            
        elseif M(i,4)~=0 && M(i,5)~=0
            if M(i,6)==0 && M(i,7)~=0
                Y(n+i,M(i,4))=1;
                Y(n+i,M(i,5))=-1;
                
                Y(n+i+1,M(i,7))=-1;
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                Y(M(i,4),n+i)=1;
                Y(M(i,5),n+i)=-1;
                
                Y(M(i,7),n+i+1)=-1;
                
            elseif M(i,6)~=0 && M(i,7)==0
                
                
                Y(n+i,M(i,4))=1;
                Y(n+i,M(i,5))=-1;
                Y(n+i+1,M(i,6))=1;
                
                
                Y(n+i,n+i)=-s*M(i,2);
                Y(n+i,n+i+1)=-s*M(i,1);
                Y(n+i+1,n+i)=-s*M(i,1);
                Y(n+i+1,n+i+1)=-s*M(i,3);
                
                Y(M(i,4),n+i)=1;
                Y(M(i,5),n+i)=-1;
                Y(M(i,6),n+i+1)=1;
                
                
            end
        end
        
    end
end
Y;
J;
J1; %zero state


E=Y\J;
e=vpa(ilaplace(E),2);% VPA : vase taghrib zadane javabe nahaee . . .
if O(1)==1
    fprintf('\n\n\n Total solution: ')
    e
end


Z1=Y\J1;
z1=vpa(ilaplace(Z1),2);% VPA : vase taghrib zadane javabe nahaee . . .
if O(2)==1
    fprintf('\n\n\n Zero state response: ')
    z1
end



z2=vpa(e-z1,2);
if O(3)==1
    fprintf('\n\n\n Zero input response: ')
    z2
end




p=det(Y);
p=sym2poly(p);
NF=roots(p);%Natural Frequency
if O(4)==1
    fprintf('\n\n\n Natural Frequency : ')
    NF
end
% ********************  peyda kardane Network function ***********************


% be dast avordane voroodi
if strcmp(K(1),'i') %age voroodi az jense jaryan bashe
    if N(1)~=0
        a=J1(N(1));
    else
        a=J1(N(2));
    end
end
if strcmp(K(1),'v') %age voroodi az jense voltage bashe
    if N(1)&&N(2)~=0
        a=Z1(N(1))-Z1(N(2)); % Z1: zero state response
        
    elseif N(1)==0 && N(2)~=0
        a=-Z1(N(2));
        
    elseif N(1)~=0 && N(2)==0
        a=Z1(N(1));
    end
end

% be dast avordane khorooji
if strcmp(K(2),'v') %age khorooji az jense voltage bashe
    if N(3)~=0 && N(4)~=0
        b=Z1(N(3))-Z1(N(4));
    elseif N(3)==0 && N(4)~=0
        b=-Z(N(4));
    elseif N(3)~=0 && N(4)==0
        b=Z1(N(3));
    end
    
end
syms s
if strcmp(K(2),'i') %age khorooji az jense jaryan bashe
    
    b=[];
    
    y=0;
    %baraye shakheye moghavemat  ha ...
    syms s
    if exist('G','var')
        
        n=size(G);
        n1=n(1);
        for i=1:n1
            if G(i,2)==N(3) && G(i,3)==N(4)
                y=y+G(i,1);
                
            elseif G(i,2)==N(4) && G(i,3)==N(3)
                y=y+G(i,1);
                
            end
        end
        b=[b y*(Z1(N(4))-Z1(N(3)))];
    else
        b=[b 0];
    end
    
    
    
    y=0;
    %baraye shakheye khazan ha ...
    syms s
    if exist('C','var')
        
        n=size(C);
        n1=n(1);
        for i=1:n1
            if C(i,2)==N(3) && C(i,3)==N(4)
                y=y+s*C(i,1);
                
            elseif C(i,2)==N(4) && C(i,3)==N(3)
                y=y+s*C(i,1);
                
            end
        end
        
        
        b=[b y*(Z1(N(3))-Z1(N(4)))];
    else
        b=[b 0];
    end
    
    
    y=0;
    %baraye shakheye self ha ...
    syms s
    if exist('L','var')
        
        n=size(L);
        n1=n(1);
        for i=1:n1
            if L(i,2)==N(3) && L(i,3)==N(4)
                y=y+1/(s*L(i,1));
                
            elseif L(i,2)==N(4) && L(i,3)==N(3)
                y=y+1/(s*L(i,1));
                
            end
        end
        b=[b y*(Z1(N(3))-Z1(N(4)))];
    else
        b=[b 0];
    end
    
end



H=vpa(b/a,2);
syms s
Y1(s)=H(1);
Y2(s)=H(2);
Y3(s)=H(3);
h=vpa(ilaplace(H),2);
syms t
y1(t)=h(1);
y2(t)=h(2);
y3(t)=h(3);
t=0:.1:10;


if O(5)==1
    fprintf('Network function : ')
    H
    
    figure
    s=(2*pi)./t;
    subplot(2,2,1)
    plot(s,Y1(s))
    xlabel('w (rad/sec)')
    ylabel('H(w) for Resistors')
    
    subplot(2,2,2)
    plot(s,Y2(s))
    xlabel('w (rad/sec)')
    ylabel('H(w) for Capacitors')
    
    subplot(2,2,3)
    plot(s,Y3(s))
    xlabel('w (rad/sec)')
    ylabel('H(w) for Inductors')
    
end


if O(6)==1
    fprintf('Impulse response  : ')
    h
    
    figure
    subplot(2,2,1)
    plot(t,y1(t))
    xlabel('t (sec)')
    ylabel('h(t) for Resistors')
    
    subplot(2,2,2)
    plot(t,y2(t))
    xlabel('t (sec)')
    ylabel('h(t) for Capacitors')
    
    subplot(2,2,3)
    plot(t,y3(t))
    xlabel('t (sec)')
    ylabel('h(t) for Inductors')
    
end


































































