% transfer matrix method: drift matrix
function mat_b = tm_drift(V1,V2,d)
    mat_b = [1,2*d/(sqrt(V1)+sqrt(V2)); 0,1];
end