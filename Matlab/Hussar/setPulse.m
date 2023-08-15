%{
地址::Matlab\Hussar\setPulse.m
+[保存文本](,setPulse)
%}

function AS=setPulse(name,profile,dtau,energy,lm,space)

AS = CEnvelope(name, space, lm);
composer = CPulseComposer(space);
composer.append('T', CSincPF('FWHM', dtau));
composer.append('X', CGaussPF('Waist', 1));
composer.append('Y', CGaussPF('Waist', 1));
AS.put(energy,composer);

setProfile(AS,profile);

end