#!/usr/bin/perl
use strict;
use warnings;
use Proc::ProcessTable;

# Obtener la tabla de procesos
my $table = Proc::ProcessTable->new();
my $is_running = 0;

# Recorrer cada proceso y verificar si es "devora_cpu"
foreach my $proc (@{ $table->table }) {
    # Usamos el método fname() para obtener el nombre del proceso
    if (defined $proc->fname && $proc->fname eq "devora_cpu") {
        $is_running = 1;
        last;
    }
}

# Mostrar el resultado
if ($is_running) {
    print "El proceso devora_cpu está en ejecución.\n";
} else {
    print "El proceso devora_cpu no se está ejecutando.\n";
}