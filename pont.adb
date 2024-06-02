--Autor: Carlos Lozano Alemañy

with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Task_Identification;  use Ada.Task_Identification;
with Ada.Numerics.Discrete_Random;  

with defmon;                   use defmon;

procedure Pont is
    n_AMBULANCIES           : constant := 1;
    n_COTXES                : constant := 5;
    Retard_en_marxa       : constant := 0.5;
    Retard_arribar_pont   : constant := 0.5;
    Retard_travessar_pont : constant := 0.5;
    -- Definicion de monitor
    monitor    : monitorrr;
    --Sleep type
    type sleepTime is range 1 .. 3;
    package time is new Ada.Numerics.Discrete_Random (sleepTime);
    Generator : time.Generator;

    -- Randomly delay for tasks
    procedure sleep is
    begin
        delay Duration (time.Random(Generator));
    end sleep;
    --------------------------------COTXE
    ---------------Definir procés
    task type tasca_cotxe is
        entry Start(num_cotxe : Natural);
    end tasca_cotxe;
    ---------------Tasca
    task body tasca_cotxe is
        id_cotxe : Natural;
        direccio : String(1..4);
    
    begin
        -- "InIt"
        accept Start (num_cotxe : Natural) do
            id_cotxe := num_cotxe;
            if (num_cotxe mod 2 = 0) then
                direccio := "Nord";
            else
                direccio := "Sud "; 
            end if;
        end Start;

        sleep; -- El temps que cada vehicle espera a posar-se en marxa
        Put_Line("El cotxe " & Natural'Image(id_cotxe) & " esta en ruta en direccio " & direccio);       
        sleep; -- El temps que cada vehicle demora per arribar al pont
        monitor.arribarPontCotxe(id_cotxe, direccio);
        monitor.entrarPontCotxe(id_cotxe, direccio);       
        monitor.sortirPont(id_cotxe, False);
    end tasca_cotxe;
    

    --------------------------------AMBULÀNCIA
    ---------------Definir procés
    task type tasca_ambulancia is
        entry Start(num_amb : Natural);
    end tasca_ambulancia;
    ---------------Tasca
    task body tasca_ambulancia is
        id : Natural;
    begin
        -- "InIt"
        accept Start (num_amb : Natural) do
            id := num_amb;
        end Start;
        
        sleep; -- El temps que cada vehicle espera a posar-se en marxa
        Ada.Text_IO.Put_Line("L'ambulancia " & Natural'Image(id) & " esta en ruta");
        sleep; -- El temps que cada vehicle demora per arribar al pont
        monitor.arribarPontAmbulancia(id);
        monitor.entrarPontAmbulancia(id);
        monitor.sortirPont(id, True);
    end tasca_ambulancia; 

    --------------------------------MAIN
    type cotxes_array is array(1..n_COTXES) of tasca_cotxe;
    cotxes : cotxes_array;
    type amb_array is array(1..n_AMBULANCIES) of tasca_ambulancia;
    ambulancies : amb_array;

begin
    
    --Monitor initialization
    --monitor.Start;
    -- Crear e iniciar tareas para coches
    for I in 1..n_COTXES loop
        cotxes(I).Start(I);
    end loop;
    -- Crear e iniciar tarea para ambulancia con ID 112
    ambulancies(1).Start(112);
    
end Pont;        
        
    
