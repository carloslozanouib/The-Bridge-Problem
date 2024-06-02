--Autor: Carlos Lozano Alemañy
with Ada.Text_IO; use Ada.Text_IO;

package body defmon is
    
    protected body monitorrr is
        --mètode que retorna la direcció inversa a la del cotxe, per saber si hi ha més
        --o menys cotxes a l'altra direcció
        function inversa(dir : String) return String is
        begin
            if dir = "SUD " then
                return "NORD";
            else
                return "SUD ";
            end if;
        end inversa;

        --Mètode que retonra el nombre de cotxes de la direcció escrita
        function getNumCotxes(dir : String) return Integer is
        begin
            if dir = "SUD " then
                return cotxesSud;
            else
                return cotxesNord;
            end if;
        end  getNumCotxes;

        --Mètode per aumentar o disminuir el nombre de cotxes que hi ha al pont
        --o esperant
        procedure actualitzarNumCotxes(dir : String; aumentar : boolean) is
        begin
            if dir = "SUD " then
                if aumentar then
                    cotxesSud := cotxesSud+1;
                else
                    cotxesSud := cotxesSud-1;
                end if;
            end if;
            if dir = "NORD" then
                if aumentar then
                    cotxesNord := cotxesNord+1;
                else
                    cotxesNord := cotxesNord-1;
                end if;
            end if;
        end actualitzarNumCotxes;
        
        procedure arribarPontCotxe(id: Integer; direccio : String) is
        begin
            --Un cotxe es prepara per entrar al pont
            --En funcio de la seva direccio augmentara el nombre de cotxes esperant al nord o al sud
            Put("El cotxe " & Integer'Image(id) & " espera a l'entrada " & direccio);
            actualitzarNumCotxes(direccio, True);
            if getNumCotxes(direccio) < getNumCotxes(inversa(direccio)) then
                hi_ha_mes_cotxes := False;
            end if;
            Put_Line(". Esperen al " & direccio & ": " & Integer'Image(getNumCotxes(direccio)+1));
        end arribarPontCotxe;
        
        --Si hi ha algun cotxe al pont, bloqueja
        entry entrarPontCotxe(id : Integer; direccio : String) when (not ambulancia and not cotxePont and hi_ha_mes_cotxes) is 
        begin
            cotxePont := True; -- EL COTXE ENTRA AL PONT
            Put_Line("El cotxe " & Integer'Image(id) & " entra al pont.");
            -- Decrementam els cotxes que esperen en una direccio en funcio de la direccio
            -- de la que ve el cotxe
            actualitzarNumCotxes(direccio, False);
            Put_Line(". Esperen al " & direccio & ": " & Integer'Image(getNumCotxes(direccio)));
        end entrarPontCotxe;
        
        procedure arribarPontAmbulancia(id: Integer) is
        begin
            Put_Line("+++++Ambulancia " & Integer'Image(id) & " espera per entrar");
            ambulancia := True;
        end arribarPontAmbulancia;
            
        --Proces gairabé identic al de entrarPontCotxe, simplement es diferencia
        --pel fet de que una ambulancia es prioritaria i que aquesta no ve de cap
        --direcció en concret;  id: identificador de la ambulancia
        entry entrarPontAmbulancia(id : Integer) when not cotxePont is
        begin
            cotxePont := True;
            Put_Line("+++++Ambulancia " & Integer'Image(id) & " es al pont");
        end entrarPontAmbulancia;

        --Proces on els vehicles surten del pont, per aquest requerim saber si el
        --vehicle que sortira es o no una ambulancia per a posar la seva variable
        --de condicio que li otorga prioritat a fals si es que surt Tipusv: indica
        --quin tipus de vehicle es seguint la llegenda d'adalt ID: identificiador
        --vehicle
        procedure sortirPont(id : Integer; tipusV : Boolean) is
        begin
            Put_Line("---->El vehicle " & Integer'Image(id) & " surt del pont");
            if tipusV then
            -- Si surt l'ambulancia possa la variable a fals
                ambulancia := False;
            end if;
            -- ha sortit un vehicle, actualitzar variable
            cotxePont := False;
        end sortirPont;

    end monitorrr;

end defmon; 



