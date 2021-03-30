function [ y ] = K_w( x )
    y = [ x(1) -x(2) -x(3) 0 0 0;
          0 -x(1) 0 x(2) -x(3) 0;
          0 0 -x(1) 0 -x(2) x(3)];
end

