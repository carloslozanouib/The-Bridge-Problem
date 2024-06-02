--Autor: Carlos Lozano Alemañy

with Ada.Text_IO; use Ada.Text_IO;

package defmon is

    protected type monitorrr is
        
        function inversa(dir : String) return String;
        function getNumCotxes(dir : String) return Integer;
        procedure actualitzarNumCotxes(dir : String; aumentar : boolean);
        procedure arribarPontCotxe(id: Integer; direccio : String);
        procedure arribarPontAmbulancia(id: Integer);
        entry entrarPontCotxe(id : Integer; direccio : String);
        entry entrarPontAmbulancia(id : Integer);
        procedure sortirPont(id : Integer; tipusV : Boolean);

    private
    --Al monitor trobam les seguents variables que ens permetran sincronitzar els diferents processos;
    --'cotxePont' es la variable de condició que indica si actualment hi ha algun cotxe en el pont
    --'ambulancia' es la variable que indica si el procés ambulancia vol entrar per a poder donar-li prioritat en el cas de que ho vulgui fer
        cotxesSud : Integer := 0;
        cotxesNord : Integer := 0;
        cotxePont : Boolean := False;
        ambulancia : Boolean := False;
        hi_ha_mes_cotxes : Boolean := True;

    end monitorrr;

end defmon;
