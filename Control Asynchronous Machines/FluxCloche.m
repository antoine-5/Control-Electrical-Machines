function f = FluxCloche(u)
    if (abs(u(1)) <= u(2))
        f = u(3);
    else
        f = u(3)*u(2)/u(1);
    end
end