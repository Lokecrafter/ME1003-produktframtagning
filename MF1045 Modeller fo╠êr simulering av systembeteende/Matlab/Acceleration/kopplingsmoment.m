function MK = kopplingsmoment(omega1)
% Funktionsfil för beräkning av maximalt överförbart kopplingsmoment som
% funktion av vinkelhastigheten hos medbringaren.
%
% OBS! Ekvationerna i funktionen ska bytas ut när ni kommer så
% långt att ni har tagit fram en modell som beskriver er egen koppling.
%
% Anders Söderberg, KTH Maskinkonstuktion, 2023-08-21

b(1) =  -3.392;
b(2) =  2.148e-004;

MK = b(1) + b(2)*omega1.^2;     % Maximalt överförbart kopplingsmoment [Nm]
MK = MK.*(MK>0);                % Ingen kontakt mellan block och trumma: MK=0 Nm

end