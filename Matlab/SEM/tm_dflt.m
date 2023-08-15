% transfer matrix method: deflection matrix
function mat_a = tm_dflt(E1,E2,V0)
    mat_a = [1,0; -1/(4*sqrt(V0))*(E2-E1),1];
end
