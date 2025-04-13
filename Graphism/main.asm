; pixel_int10.asm
; Assemble avec: nasm -f bin pixel_int10.asm -o pixel.com
org 0x100

RED equ 0x04
BLUE equ 0x09
GREEN equ 0x02

start:
    ; passer en mode graphique 13h (320x200, 256 couleurs)
    mov ah, 0x00
    mov al, 0x13
    int 0x10

    ; initialiser la souris
    mov ax, 0
    int 33h


main_loop:
    mov ax, 3
    int 33h
    mov bx, cx    ; sauver X dans BX
    mov si, dx    ; sauver Y dans SI

    ; Dessiner quelques pixels avec int 10h / fonction 0Ch
    ; pixel rouge en (100, 100)
    mov ah, 0x0C
    mov al, RED          ; couleur rouge
    mov bh, 0x00         ; page vidéo
    mov cx, 100          ; x
    mov dx, 100          ; y
    int 0x10

    mov ah, 0x0C
    mov al, RED          ; couleur rouge
    mov bh, 0x00         ; page vidéo
    mov cx, [bx]         ; x
    mov dx, [si]         ; y
    int 0x10

    ; pixel vert en (120, 110)
    mov ah, 0x0C
    mov al, GREEN        ; couleur vert
    mov cx, 120
    mov dx, 110
    int 0x10

    ; pixel bleu clair en (140, 90)
    mov ah, 0x0C
    mov al, BLUE        ; couleur bleu clair
    mov cx, 140
    mov dx, 90
    int 0x10

    ; attendre une touche
    mov ah, 0
    int 0x16

    jmp main_loop
