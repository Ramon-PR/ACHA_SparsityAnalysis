function c = mefwa2(x,pat,tp)
% mefwa2 - 2D forward mirror-extended wave atom transform
% -----------------
% INPUT
% --
% x is a real N-by-N matrix. N is a power of 2.
% --
% pat specifies the type of frequency partition which satsifies
% parabolic scaling relationship. pat can either be 'p' or 'q'.
% --
% tp is the type of tranform.
% 	'ortho': frame based on the orthobasis construction of 
% 		the standard wave atom
% 	'directional': real-valued frame with single oscillation direction
% 	'complex': complex-valued frame
% -----------------
% OUTPUT
% --
% c is a cell array which contains the wave atom coefficients. If
% tp=='ortho', then c{j}{m1,m2}(n1,n2) is the coefficient at scale j,
% frequency index (m1,m2) and spatial index (n1,n2). If
% tp=='directional', then c{j,d}{m1,m2}(n1,n2) with d=1,2 are the
% coefficients at scale j, frequency index (m1,m2) and spatial index
% (n1,n2). If tp=='complex', then c{j}{m1,m2)(n1,n2) is the
% complex-valued coefficients at scale j, frequency index (m1,m2) and
% spatial index (n1,n2). Notice thatm, for the mirror-extended wave
% atoms, the spatial indices wrap around once.
% -----------------
% Written by Lexing Ying and Laurent Demanet, 2007
  
  if( ismember(tp, {'ortho','directional','complex'})==0 | ismember(pat, {'p','q','u'})==0 )    error('wrong');  end
  
  if(    strcmp(tp,'ortho')==1)
    %----------------------------------------------------------------------------------------------------------
    N = size(x,1);
    lst = freq_pat(N,pat);
    E = 2^length(lst);
    
    f = dct2(x);
    f = mescatter(f,E);
    f = mescatter(f',E)';
    A = size(f,1);
    
    c = cell(length(lst),1);
    %------------------
    for s=1:length(lst)
      nw = length(lst{s});
      c{s} = cell(nw,nw);
      for I=0:nw-1
        for J=0:nw-1
          if(lst{s}(I+1)==0 & lst{s}(J+1)==0)
            c{s}{I+1,J+1} = [];
          else
            B = 2^(s-1);
            D = 2*B;
            Ict = I*B;      Jct = J*B; %starting position in freq
            if(mod(I,2)==0)
              Ifm = Ict-2/3*B;        Ito = Ict+4/3*B;
            else
              Ifm = Ict-1/3*B;        Ito = Ict+5/3*B;
            end
            if(mod(J,2)==0)
              Jfm = Jct-2/3*B;        Jto = Jct+4/3*B;
            else
              Jfm = Jct-1/3*B;        Jto = Jct+5/3*B;
            end
            res = zeros(D,D);
            for id=0:1
              if(id==0)
                Idx = [ceil(Ifm):floor(Ito)];      Icf = kf_rt(Idx/B*pi, I);
              else
                Idx = [ceil(-Ito):floor(-Ifm)];      Icf = kf_lf(Idx/B*pi, I);
              end
              for jd=0:1
                if(jd==0)
                  Jdx = [ceil(Jfm):floor(Jto)];      Jcf = kf_rt(Jdx/B*pi, J);
                else
                  Jdx = [ceil(-Jto):floor(-Jfm)];      Jcf = kf_lf(Jdx/B*pi, J);
                end
                res(mod(Idx,D)+1,mod(Jdx,D)+1) = res(mod(Idx,D)+1,mod(Jdx,D)+1) + conj( Icf.'*Jcf ) .* f(mod(Idx,A)+1,mod(Jdx,A)+1);
              end
            end
            c{s}{I+1,J+1} = ifft2(res) * sqrt(prod(size(res))) / 2; %LEXING: IMPORTANT
          end
        end
      end
    end
    
  elseif(strcmp(tp,'complex')==1)
    %----------------------------------------------------------------------------------------------------------
    N = size(x,1);
    lst = freq_pat(N,pat);
    E = 2^length(lst);
    
    f = dct2(x);
    f = mescatter(f,E);
    f = mescatter(f',E)';
    A = size(f,1);
    
    c = cell(length(lst),1);
    %------------------
    for s=1:length(lst)
      nw = length(lst{s});
      c{s} = cell(nw,nw);
      for I=0:nw-1
        for J=0:nw-1
          if(lst{s}(I+1)==0 & lst{s}(J+1)==0)
            c{s}{I+1,J+1} = [];
          else
            B = 2^(s-1);
            D = 2*B;
            Ict = I*B;      Jct = J*B; %starting position in freq
            if(mod(I,2)==0)
              Ifm = Ict-2/3*B;        Ito = Ict+4/3*B;
            else
              Ifm = Ict-1/3*B;        Ito = Ict+5/3*B;
            end
            if(mod(J,2)==0)
              Jfm = Jct-2/3*B;        Jto = Jct+4/3*B;
            else
              Jfm = Jct-1/3*B;        Jto = Jct+5/3*B;
            end
            res = zeros(D,D);
            Idx = [ceil(Ifm):floor(Ito)];      Icf = kf_rt(Idx/B*pi, I);
            Jdx = [ceil(Jfm):floor(Jto)];      Jcf = kf_rt(Jdx/B*pi, J);
            res(mod(Idx,D)+1,mod(Jdx,D)+1) = res(mod(Idx,D)+1,mod(Jdx,D)+1) + abs( Icf.'*Jcf ) .* f(mod(Idx,A)+1,mod(Jdx,A)+1);
            c{s}{I+1,J+1} = ifft2(res) * sqrt(prod(size(res)));
          end
        end
      end
    end
    
  elseif(strcmp(tp,'directional')==1)
    %-----------------------------------------------------------------------------------------------------------
    N = size(x,1);
    lst = freq_pat(N,pat);
    E = 2^length(lst);
    
    f = dct2(x);
    f = mescatter(f,E);
    f = mescatter(f',E)';
    A = size(f,1);
    
    c1 = cell(length(lst),1);
    c2 = cell(length(lst),1);
    %------------------
    for s=1:length(lst)
      nw = length(lst{s});
      c1{s} = cell(nw,nw);
      c2{s} = cell(nw,nw);
      for I=0:nw-1
        for J=0:nw-1
          if(lst{s}(I+1)==0 & lst{s}(J+1)==0)
            c1{s}{I+1,J+1} = [];
            c2{s}{I+1,J+1} = [];
          else
            B = 2^(s-1);
            D = 2*B;
            Ict = I*B;      Jct = J*B; %starting position in freq
            if(mod(I,2)==0)
              Ifm = Ict-2/3*B;        Ito = Ict+4/3*B;
            else
              Ifm = Ict-1/3*B;        Ito = Ict+5/3*B;
            end
            if(mod(J,2)==0)
              Jfm = Jct-2/3*B;        Jto = Jct+4/3*B;
            else
              Jfm = Jct-1/3*B;        Jto = Jct+5/3*B;
            end
            
            res = zeros(D,D);
            Idx = [ceil(Ifm):floor(Ito)];      Icf = kf_rt(Idx/B*pi, I);
            Jdx = [ceil(Jfm):floor(Jto)];      Jcf = kf_rt(Jdx/B*pi, J);
            res(mod(Idx,D)+1,mod(Jdx,D)+1) = res(mod(Idx,D)+1,mod(Jdx,D)+1) + conj( Icf.'*Jcf ) .* f(mod(Idx,A)+1,mod(Jdx,A)+1);
            Idx = [ceil(-Ito):floor(-Ifm)];      Icf = kf_lf(Idx/B*pi, I);
            Jdx = [ceil(-Jto):floor(-Jfm)];      Jcf = kf_lf(Jdx/B*pi, J);
            res(mod(Idx,D)+1,mod(Jdx,D)+1) = res(mod(Idx,D)+1,mod(Jdx,D)+1) + conj( Icf.'*Jcf ) .* f(mod(Idx,A)+1,mod(Jdx,A)+1);
            tmp1 = ifft2(res) * sqrt(prod(size(res)));
            %c1{s}{I+1,J+1} = tmp1(:,end/2+1:end)/sqrt(2);
            c1{s}{I+1,J+1} = tmp1(:,1:end/2)/sqrt(2);
            
            res = zeros(D,D);
            Idx = [ceil(Ifm):floor(Ito)];      Icf = kf_rt(Idx/B*pi, I);
            Jdx = [ceil(-Jto):floor(-Jfm)];      Jcf = kf_lf(Jdx/B*pi, J);
            res(mod(Idx,D)+1,mod(Jdx,D)+1) = res(mod(Idx,D)+1,mod(Jdx,D)+1) + conj( Icf.'*Jcf ) .* f(mod(Idx,A)+1,mod(Jdx,A)+1);
            Idx = [ceil(-Ito):floor(-Ifm)];      Icf = kf_lf(Idx/B*pi, I);
            Jdx = [ceil(Jfm):floor(Jto)];      Jcf = kf_rt(Jdx/B*pi, J);
            res(mod(Idx,D)+1,mod(Jdx,D)+1) = res(mod(Idx,D)+1,mod(Jdx,D)+1) + conj( Icf.'*Jcf ) .* f(mod(Idx,A)+1,mod(Jdx,A)+1);
            tmp2 = ifft2(res) * sqrt(prod(size(res)));
            %c2{s}{I+1,J+1} = tmp2(:,end/2+1:end)/sqrt(2);
            c2{s}{I+1,J+1} = tmp2(:,1:end/2)/sqrt(2);
          end
        end
      end
    end
    c = [c1 c2];
  else
    error('wrong');
  end
  
  