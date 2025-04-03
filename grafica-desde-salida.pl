#!/usr/bin/perl
use strict;
use warnings;
use Excel::Writer::XLSX;

# Declarar arrays
my (@nombres, @porcentajes);

# Abrir el fichero salida.txt
open(my $fh, '<', 'salida.txt') or die "No se puede abrir salida.txt: $!";

# Leer línea por línea
while (my $line = <$fh>) {
    chomp $line;
    my @cols = split /\s+/, $line;  # Separar por espacios
    push @porcentajes, $cols[1];  # Segundo elemento
    push @nombres, $cols[-1];     # Último elemento
}
close($fh);

# Crear un nuevo libro de Excel
my $workbook  = Excel::Writer::XLSX->new('chart.xlsx');
my $worksheet = $workbook->add_worksheet();
my $chart     = $workbook->add_chart( type => 'pie' );

# Escribir los datos en la hoja de cálculo
$worksheet->write(0, 0, ['Nombre']);
$worksheet->write(0, 1, ['Porcentaje']);
for my $i (0 .. $#nombres) {
    $worksheet->write($i + 1, 0, $nombres[$i]);
    $worksheet->write($i + 1, 1, $porcentajes[$i]);
}

# Configurar el gráfico
$chart->add_series(
    categories => "=Sheet1!\$A\$2:\$A\$" . (scalar(@nombres) + 1),
    values     => "=Sheet1!\$B\$2:\$B\$" . (scalar(@porcentajes) + 1),
);

# Guardar el archivo Excel
$workbook->close();

print "Gráfico generado en chart.xlsx\n";
