function omr = Omega_mr(u)
    if(u(2) <= 1e-8)
        omr = 0;
    else
        omr = u(4) + u(3)/u(1)/u(2);
    end
end