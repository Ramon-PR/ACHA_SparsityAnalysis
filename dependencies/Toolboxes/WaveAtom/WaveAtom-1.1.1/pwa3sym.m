function [a1,a2,a3,ww,b1,b2,b3,zz] = pwa3sym(N,pat,tp)
% pwa3sym - get position information
% -----------------
% INPUT
% --
% N -- size
% --
% pat specifies the type of frequency partition which satsifies
% parabolic scaling relationship. pat can either be 'p' or 'q'.
% --
% tp is the type of tranform.
% 	'ortho': orthobasis
% -----------------
% OUTPUT
% --
% a1,a2,a3 are arrays that contain the centers of the wave atoms
% in spatial domain.
% --
% ww is an array that contains the widths of the wave atoms
% in spatial domain.
% --
% b1,b2,b3 are arrays that contain the centers of the wave atoms
% in frequency domain.
% --
% zz is an array that contains the widths of the wave atoms
% in frequency domain.
% --
% -----------------
% Written by Lexing Ying and Laurent Demanet, 2007

  
  if( ismember(tp, {'ortho','directional','complex'})==0 | ismember(pat, {'p','q','u'})==0 )    error('wrong');  end
  
  [x1,x2,x3,w,k1,k2,k3,z] = pwa3(N,pat,tp);
  a1 = zeros(N,N,N);  a2 = zeros(N,N,N);  a3 = zeros(N,N,N);
  ww = zeros(N,N,N);
  b1 = zeros(N,N,N);  b2 = zeros(N,N,N);  b3 = zeros(N,N,N);
  zz = zeros(N,N,N);
  
  for s=1:length(x1)
    D = 2^s;
    nw = length(x1{s});
    for I=0:nw-1
      for J=0:nw-1
        for K=0:nw-1
          if(~isempty(x1{s}{I+1,J+1,K+1}))
            a1( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = x1{s}{I+1,J+1,K+1};
            a2( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = x2{s}{I+1,J+1,K+1};
            a3( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = x3{s}{I+1,J+1,K+1};
            ww( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = w{ s}{I+1,J+1,K+1};
            
            b1( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = k1{s}{I+1,J+1,K+1};
            b2( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = k2{s}{I+1,J+1,K+1};
            b3( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = k3{s}{I+1,J+1,K+1};
            zz( I*D+[1:D], J*D+[1:D], K*D+[1:D]) = z{ s}{I+1,J+1,K+1};
          end
        end
      end
    end
  end
  