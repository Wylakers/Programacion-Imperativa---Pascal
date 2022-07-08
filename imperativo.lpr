program imperativo;

// Realizado por Rodrigo Pérez Peña - 20191544
{$mode objfpc}{$H+}

uses
  crt,
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes
  { you can add units after this };

type
  // Creación del alumno: Código del estudiante, curso y nota.
  Alumno = record
    codigo: array[1..12] of char;
    curso: array[1..6] of char;
    nota: integer;
  end;

  // Se genera el nodo
  puntero = ^nodo;
  nodo = record
    datos: Alumno;
    siguiente: puntero;
    end;
  var inicio: puntero;


// Procedimiento para crear una lista
procedure crearLista();
// Variables a usar
var
  temp: puntero;
  pos: puntero;
  archivo: text;

//Procedimiento
begin
  // Asignamos el archivo a la variable "archivo"
  assign(archivo,'C:\Users\pegas\Desktop\Trabajo LP\Alumnos.txt');
  // Abrimos el archivo
  reset(archivo);
  writeln('Abriendo archivo.');
  writeln;
  // New() se encarga de asignar memoria a una variable
  new(temp);
  // Se comprueba si se pudo asignar memoria
  // Si no se pudo, se muestra un mensaje que no hay espacio
  if (temp=NIL) then
  begin
    writeln('No hay espacio en memoria.');
  end
  else
  begin
    // EOF = end-of-file / Fin del archivo
    // Mientras que el archivo no acabe...
    while not EOF(archivo) do
    begin
      // Variable estudiante de tipo Alumno
      with temp^ do
      // Leemos el archivo y lo alojamos en la variables correspondientes
      begin
        readln(archivo, temp^.datos.codigo);
        readln(archivo, temp^.datos.curso);
        readln(archivo, temp^.datos.nota);
        readln(archivo);
      end;
      // Cargamos los datos del estudiante al nodo temp
    end;
    temp^.siguiente:=nil;
    { Si la cabeza de la lista es NULO, temp toma el valor de la cabeza}
    if (inicio=NIL) then
    begin
      inicio:= temp;
    end
    { Si no está vacía la lista, se procede a tomar una variable de ayuda
      que recorrerá todo la lista hasta que su puntero
      llegue a NULO, cuando el puntero sea NULO, este puntero se iguala al nodo
      que ya teníamos y más arriba ya se especifica que el puntero de temp o
      temp^.siguiente es NULO o NIL}
    else
    begin
      pos := inicio;
      while (pos^.siguiente<>NIL) do
      begin
        pos := pos^.siguiente;
      end;
      pos^.siguiente:= temp;
    end;
  end;
  close(archivo);
end;


// Procedimiento para mostrar la Lista
procedure mostrarLista();
var pos: puntero;
begin
  // Si está vacía lo imprimimos.
  if (inicio = NIL) then
  begin
    writeln('Lista vacia.');
  end
  {Mientras que si no está vacía se inicia la variable "Pos" con la cabeza
  de la lista, la cual usamos para recorrer todos los nodos de la lista
  e imprimirlos a través de un while que verifica que si se llega al final
  se acaba de imprimir.}
  else
  begin
    pos := inicio;
    writeln;
    writeln('Elementos de la Lista: ');
    while (pos <> NIL) do
    begin
       writeln('*********************************');
       write('Codigo del estudiante: ',pos^.datos.codigo); writeln;
       write('Codigo del curso: ',pos^.datos.curso); writeln;
       write('Nota del curso: ',pos^.datos.nota); writeln;
       writeln('*********************************');
       writeln;
       writeln;
       pos:=pos^.siguiente;
  end;
  end;
end;


{Procedimiento para ingresar un nodo a la Lista}
procedure ingresarNodo();
{Inicializamos las variables a usar}
var
  temp: puntero;
  pos: puntero;

{Preguntamos los datos a ingresar y lo almacenamos en un nodo}
begin
  new(temp);
  if(temp=NIL) then
  begin
    writeln('No hay espacio en memoria.');
    exit;
  end
  else
  begin
    writeln('*********************************');
    writeln('Ingrese los datos.');
    write('Codigo del estudiante: ');
    readln(temp^.datos.codigo);
    write('Codigo del curso: ');
    readln(temp^.datos.curso);
    write('Nota del curso: ');
    readln(temp^.datos.nota);
    writeln('*********************************');
    writeln;
    temp^.siguiente:=NIL;
    {Al igual que en crearLista(), preguntamos si está vacía o está llena la lista.
    Si está vacía el valor ingresado se pone como cabeza, si no está vacía,
    se recorre la lista y se ingresa al final de esta.}
    if (inicio=NIL) then
    begin
      inicio:= temp;
    end
    else
    begin
      pos := inicio;
      while (pos^.siguiente<>NIL) do
      begin
        pos := pos^.siguiente;
      end;
      pos^.siguiente:= temp;
    end;
  end;
end;


// Procedimiento para obtener el promedio de un estudiante
procedure promedioEstudiante();
{Inicializamos las variables}
var
  cEstudiante: array[1..12] of char;
  temp: puntero;
  suma: integer;
  promedio: real;
  contador: integer;
begin
  {Preguntamos el codigo del estudiante}
  suma:=0;
  contador:=0;
  writeln('Obtener promedio de cursos de un estudiante "X".');
  write('Ingrese el codigo del estudiante: ');
  readln(cEstudiante);
  temp:=inicio;
  {Se verifica que la lista no esté vacía y comparamos el input del usuario
  con los datos de cada nodo con el fin de encontrar similitud en algún código
  de estudiante. Si se encuentra se suman las notas y tenemos un contador que
  aumenta en uno cada vez que realiza una iteración. Finalmente, sacamos el promedio
  con estas dos variable y las imprimimos.}
  while (temp <> NIL) do
  begin
    if(temp^.datos.codigo=cEstudiante) then
    begin
      suma:=suma+temp^.datos.nota;
      contador:=contador+1;
    end;
    temp:=temp^.siguiente;
  end;
  promedio:=suma/contador;
  writeln;
  writeln('Resultado:');
  writeln('Suma de todas las notas: ',suma);
  writeln('Cantidad de cursos: ',contador);
  writeln('Promedio de todos lo cursos del estudiante ',cEstudiante,': ',promedio:0:2);
  writeln;
  writeln;
end;


// Procedimiento para hallar la cantidad de alumnos de un curso
procedure cantidadAlumnos();
{Inicializamos las variables}
var
  cCurso: array[1..6] of char;
  temp: puntero;
  contador: integer;
begin
  {Preguntamos el código del curso}
  contador:=0;
  writeln('Cantidad de alumnos que llevan el curso "Y".');
  write('Ingrese el codigo del curso: ');
  readln(cCurso);
  temp:=inicio;
  {Se verifica que la lista no esté vacía y comparamos el input del usuario
  con los datos de cada nodo con el fin de encontrar similitud en algún código
  de curso. Si se encuentra el curso deseado, el contador aumenta en uno, este
  contador significa la cantidad de alumnos que están inscritos en este y aumenta
  con cada iteración lo que supone un alumno más. Finalmente, imprimimos el resultado.}
  while (temp <> NIL) do
  begin
    if(temp^.datos.curso = cCurso) then
    begin
      contador:=contador+1;
    end;
    temp:=temp^.siguiente;
  end;
  writeln;
  writeln('Resultado');
  writeln('Cantidad de alumnos que llevan el curso ', cCurso,': ',contador);
  writeln;
  writeln;
end;

// Variable opción para el menú
var opcion: integer;


// Función principal
begin
  // Limpiamos pantalla
  Clrscr;
  // Creamos la lista y cargamos los datos del archivo automáticamente.
  crearLista();
  // Menú con las opciones a elegir
  repeat
    begin
      writeln('------------ MENU ------------');
      writeln('1. Calcular promedio de un estudiante.');
      writeln('2. Calcular cantidad de estudiantes en un curso.');
      writeln('3. Ingresar informacion de un estudiante.');
      writeln('4. Mostrar Lista');
      writeln('0. Salir');
      write('Ingrese el numero de su opcion: ');
      readln(opcion);
      writeln;
      {En este apartado, en base a la opción elegida, se llama al procedimiento
      correspondiente y muestra el resultado.}
      case (opcion) of
         1:       //Promedio de cursos
           begin
              promedioEstudiante()
           end;
         2:       //Cantidad de alumnos
           begin
             cantidadAlumnos()
           end;
         3:       //Ingresar alumno
           begin
             ingresarNodo();
           end;
         4:       //Mostrar lista
           begin
             mostrarLista();;
           end;
         0:       //Salir
           begin
             exit;
           end;
      // Si no si ingresó una opción correcta, se muestra por pantalla
      else
      begin
        writeln();
        writeln('Ingrese una opción correcta.');
        writeln();
      end;
      end;
      end;
  until (opcion=0);
end.


