% drawRunge.m 
% script 
% 
% draw the Runge function 
% 
% see runge.m 


a = -1; 
b = 1; 
n = 201; 

x = linspace(a, b, n); 
y = runge( x );

figure(1) 
plot( x, y, 'b.' ); 
xlabel( 'x' ) 
ylabel( 'Runge(x)' ) 
title( 'Runge function' ) 

figure(2) 
semilogy( x, y, 'm.' ) ; 
xlabel( 'x' ) 
ylabel( 'log10( Runge(x) ) ' )  
title( 'Runge function in log10 scale' ) 


% the end 

% ------------------
%    Xiaobai Sun 
%    Duke CS 
%    for NA classes 
% -------------------