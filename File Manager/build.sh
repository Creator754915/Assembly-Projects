#!/bin/bash

# Nom du fichier ASM source
SRC="file_manager.asm"

# Nom des fichiers générés
OBJ="file_manager.o"
OUT="file_manager.exe" 

# Compilation avec NASM
echo "[+] Assemblage de $SRC..."
nasm -f elf32 -o "$OBJ" "$SRC"

# Edition de lien avec ld
echo "[+] Linkage pour créer $OUT..."
ld -m elf_i386 -o "$OUT" "$OBJ"

# Vérification
if [ -f "$OUT" ]; then
    echo "[✔] Compilation réussie. Fichier exécutable : $OUT"
else
    echo "[✘] Erreur lors de la compilation."
fi
