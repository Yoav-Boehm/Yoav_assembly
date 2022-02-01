IDEAL
MODEL small
STACK 100h
DATASEG

mousex dw 0
mousey dw 0

array dw 0, 100, 200

cube7x dw 220
cube6x dw 190
cube5x dw 45
cube4x dw 90
cube3x dw 10
cube2x dw 120
cube1x dw 160

cube7y dw 30
cube6y dw 120
cube5y dw 180
cube4y dw 200
cube3y dw 20
cube2y dw 150
cube1y dw 100

cube7dir dw 0
cube6dir dw 0
cube5dir dw 0
cube4dir dw 0
cube3dir dw 0
cube2dir dw 0
cube1dir dw 0
color db 15

player_x dw 100
player_y dw 100
player_dir db 0

shot1x dw 0
shot1y dw 0
shot1incline dw 0, 0
CODESEG


proc x_change

;; 04bh = left
;; 04dh = right
;; 050h = down
;; 048h = up

    cmp al, 04bh
    je left

    cmp al, 04dh
    je right

    cmp al, 050h
    je down

    cmp al, 048h
    je up

left:
mov ax, [si]
dec ax
mov [si], ax
    jmp con
right:
mov ax, [si]
inc ax
mov [si], ax
    jmp con
down:
mov ax, [di]
inc ax
mov [di], ax
    jmp con
up:
mov ax, [di]
dec ax
mov [di], ax
    jmp con
con:
    ;clear argument
    ;add sp, 2
    ret
endp

proc change_dir
;comparing
cmp ax, 01h
je dir_1

cmp ax, 02h
je dir_2

cmp ax, 03h
je dir_3

cmp ax, 04h
je dir_4
jmp compare

dir_1: ;two left one up
mov [color], 0
call print_cube
mov al, 04bh
call x_change
mov al, 04bh
call x_change
mov al, 048h
call x_change
mov [color], 15
jmp continue

dir_2: ;two right one up
mov [color], 0
call print_cube
mov al, 04dh
call x_change
mov al, 04dh
call x_change
mov al, 048h
call x_change
mov [color], 15
jmp continue

dir_3: ;two left one down
mov [color], 0
call print_cube
mov al, 04bh
call x_change
mov al, 04bh
call x_change
mov al, 050h
call x_change
mov [color], 15
jmp continue

dir_4: ;one left two up
mov [color], 0
call print_cube
mov al, 04bh
call x_change
mov al, 048h
call x_change
mov al, 048h
call x_change
mov [color], 15
jmp continue

;more comparing
compare:
cmp ax, 05h
je dir_5

cmp ax, 06h
je dir_6

cmp ax, 07h
je dir_7

dir_5: ;one right two up
mov [color], 0
call print_cube
mov al, 04dh
call x_change
mov al, 048h
call x_change
mov al, 048h
call x_change
mov [color], 15
jmp continue

dir_6: ;one left two down
mov [color], 0
call print_cube
mov al, 04bh
call x_change
mov al, 050h
call x_change
mov al, 050h
call x_change
mov [color], 15
jmp continue

dir_7: ;one right two down
mov [color], 0
call print_cube
mov al, 04dh
call x_change
mov al, 050h
call x_change
mov al, 050h
call x_change
mov [color], 15
jmp continue

continue:
ret
endp

proc enter_graphic_mode
    mov ax, 13h
    int 10h
    ret
endp

proc print_dot_from_memory
    push ax
push bx
push cx
push dx

    mov cx, [si]
    mov al, [color]
    mov dx, [di]
    mov bh, 0h
mov ah, 0ch
    int 10h

pop dx
pop cx
pop bx
pop ax
    ret
endp
proc print_cube
mov bx, 10h
up_10:
call print_dot_from_memory
mov al, 048h
call x_change
dec bx
cmp bx, 0h
jne up_10
mov bx, 10h
right_10:
call print_dot_from_memory
mov al, 04dh
call x_change
dec bx
cmp bx, 0h
jne right_10
mov bx, 10h
down_10:
call print_dot_from_memory
mov al, 050h
call x_change
dec bx
cmp bx, 0h
jne down_10
mov bx, 10h
left_10:
call print_dot_from_memory
mov al, 04bh
call x_change
dec bx
cmp bx, 0h
jne left_10
ret
endp
proc draw_player
mov bx, 02h
position_start:
mov al, 048h
call x_change
mov al, 04bh
call x_change
call print_dot_from_memory
dec bx
cmp bx, 0h
jne position_start
mov bx, 02h
twice:
mov cx, 04h
right_4:
mov al, 04dh
call x_change
call print_dot_from_memory
dec cx
cmp cx, 0h
jne right_4
mov al, 050h
call x_change
call print_dot_from_memory
mov cx, 04h
left_4:
mov al, 04bh
call x_change
call print_dot_from_memory
dec cx
cmp cx, 0h
jne left_4
mov al, 050h
call x_change
call print_dot_from_memory
dec bx
cmp bx, 0h
jne twice
mov cx, 04h
last_right:
mov al, 04dh
call x_change
call print_dot_from_memory
dec cx
cmp cx, 0h
jne last_right
mov bx, 02h
position_end:
mov al, 048h
call x_change
mov al, 04bh
call x_change
dec bx
cmp bx, 0h
jne position_end

ret
endp

proc player_change

;; 04bh = left
;; 04dh = right
;; 050h = down
;; 048h = up

    cmp [player_dir], 'a'
    je left_player

    cmp [player_dir], 'd'
    je right_player

    cmp [player_dir], 's'
    je down_player

    cmp [player_dir], 'w'
    je up_player

left_player:
mov ax, [player_x]
dec ax
mov [player_x], ax
    jmp con_player
right_player:
mov ax, [player_x]
inc ax
mov [player_x], ax
    jmp con_player
down_player:
mov ax, [player_y]
inc ax
mov [player_y], ax
    jmp con_player
up_player:
mov ax, [player_y]
dec ax
mov [player_y], ax
    jmp con_player
con_player:
    ;clear argument
    ;add sp, 2
    ret
endp

proc move_player
mov si, offset player_x
mov di, offset player_y
mov [color], 0
call draw_player
call player_change
mov [color], 15
call draw_player

ret
endp

proc draw_pixle
push ax
push dx
push cx

mov si, offset mousex
mov di, offset mousey
mov [color], 12
call print_dot_from_memory

mov [color], 15
pop ax
pop dx
pop cx
ret
endp

proc shoot_2
cmp cx, 1
je num_1
cmp cx, 2
je num_2
cmp cx, 3
je num_3
cmp cx, 4
je num_4

num_1:	
	mov ax, [mousex]
	mov bx, [mousey]
	sub ax, [player_x]
	sub bx, [player_y]
	jmp number
num_2:	
	mov ax, [mousex]
	mov bx, [player_y]
	sub ax, [player_x]
	sub bx, [mousey]
	jmp number
num_3:
	mov ax, [player_x]
	mov bx, [player_y]
	sub ax, [mousex]
	sub bx, [mousey]
	jmp number
num_4:
	mov ax, [player_x]
	mov bx, [mousey]
	sub ax, [mousex]
	sub bx, [player_y]
number:
	mov si, offset shot1x

	ret
endp 

proc shoot
push ax
push bx
push cx
push dx

mov ax, [player_x]
mov bx, [player_y]

mov [shot1x], ax
mov [shot1y], bx

mov ax, [mousey]
mov bx, [mousex]
mov dx, 0
mov si, offset shot1y
	
cmp bx, [player_x]
jl case3

cmp ax, [player_y]
jl case2

case1:
	mov [shot1incline + 2], 1
	sub ax, [player_y]
	sub bx, [player_x]
	cmp ax, bx
	ja no_need
	mov [shot1incline + 2], 5
	mov cx, 1
	call shoot_2
no_need:
		
	div bx

	
	mov cx, [si]
	add cx, dx
	mov [si], cx
	
	jmp end_cases
case2:
	mov [shot1incline + 2], 2
	sub ax, [player_y]
	mov cx, [mousey]
	sub cx, ax
	sub cx, ax
	sub cx, [player_y]
	mov ax, cx
	
	sub bx, [player_x]
	cmp ax, bx
	ja no_need2
	mov cx, 2
	mov [shot1incline + 2], 6
	call shoot_2	
no_need2:

	div bx
	cmp si, offset shot1x
	je shalom
	mov cx, [si]
	sub cx, dx
	mov [si], cx
	jmp end_cases
shalom:
	mov cx, [si]
	add cx, dx
	mov [si], cx
	jmp end_cases
case3:
cmp ax, [player_y]
ja case4
	mov [shot1incline + 2], 3
	mov ax, [player_y]
	mov bx, [player_x]
	sub ax, [mousey]
	sub bx, [mousex]
	cmp ax, bx
	ja no_need3
	mov cx, 3
	mov [shot1incline + 2], 7
	call shoot_2
no_need3:
		
	div bx

	
	mov cx, [si]
	sub cx, dx
	mov [si], cx
	
	jmp end_cases
case4:
	mov [shot1incline + 2], 4
	sub ax, [player_y]
	sub bx, [player_x]
	mov cx, [mousex]
	sub cx, bx
	sub cx, bx
	sub cx, [player_x]
	mov bx, cx
	
	cmp ax, bx
	ja no_need4
	mov [shot1incline + 2], 8
	mov cx, 4
	call shoot_2
no_need4:
	div bx	
	cmp si, offset shot1x
	je shalom2
	mov cx, [si]
	add cx, dx
	mov [si], cx
	jmp end_cases
shalom2:
	mov cx, [si]
	sub cx, dx
	mov [si], cx
	jmp end_cases
	
end_cases:
mov [shot1incline], ax

mov si, offset shot1x
mov di, offset shot1y
call print_dot_from_memory

pop dx
pop cx
pop bx
pop ax

ret
endp

proc move_shot

	mov si, offset shot1x
	mov di, offset shot1y

	mov [color], 0
	call print_dot_from_memory
	
	mov cx, [shot1incline]

	cmp [shot1incline + 2], 1
	je case1_
	cmp [shot1incline + 2], 2
	je case2_
	cmp [shot1incline + 2], 3
	je case3_
	cmp [shot1incline + 2], 4
	je case4_
	cmp [shot1incline + 2], 5
	je case5_
	cmp [shot1incline + 2], 6
	je case6_
	jmp other_cases2
case1_:

	mov ax, [shot1x]
	inc ax
	mov [shot1x], ax
	
	mov bx, [shot1y]
	add bx, cx
	mov [shot1y], bx
	jmp end_case
case2_:
	
	mov ax, [shot1x]
	inc ax
	mov [shot1x], ax
	
	mov bx, [shot1y]
	sub bx, cx
	mov [shot1y], bx
	jmp end_case
case3_:
	mov ax, [shot1x]
	dec ax
	mov [shot1x], ax
	
	mov bx, [shot1y]
	sub bx, cx
	mov [shot1y], bx
	jmp end_case
case4_:
	mov ax, [shot1x]
	dec ax
	mov [shot1x], ax
	
	mov bx, [shot1y]
	add bx, cx
	mov [shot1y], bx
	jmp end_case
case5_:
	mov ax, [shot1y]
	inc ax
	mov [shot1y], ax
	
	mov bx, [shot1x]
	add bx, [shot1incline]
	mov [shot1x], bx
	jmp end_case
case6_:
	mov ax, [shot1y]
	dec ax
	mov [shot1y], ax
	
	mov bx, [shot1x]
	add bx, [shot1incline]
	mov [shot1x], bx
	jmp end_case
other_cases2:
cmp [shot1incline + 2], 7
	je case7_
cmp [shot1incline + 2], 8
	je case8_
case7_:
	mov ax, [shot1y]
	dec ax
	mov [shot1y], ax
	
	mov bx, [shot1x]
	sub bx, [shot1incline]
	mov [shot1x], bx
	jmp end_case
case8_:
	mov ax, [shot1y]
	inc ax
	mov [shot1y], ax
	
	mov bx, [shot1x]
	sub bx, [shot1incline]
	mov [shot1x], bx
	jmp end_case
end_case:
	
	mov si, offset shot1x
	mov di, offset shot1y
	
	mov [color], 15
	call print_dot_from_memory
	
	ret
endp

proc color_pixel
    call enter_graphic_mode

next:

;MOV     CX, 01H
;MOV     DX, 44H
;MOV     AH, 86H
;INT     15H

push cx
push dx
push ax
mov bx, 10h
mov ax, 0001h
int 33h
mov ax, 0003h
int 33h
mov [mousey], dx
mov ax, cx
sar ax, 1
mov [mousex], ax
pop ax
pop dx
pop cx
call draw_pixle
cmp bx, 1
jne no_click
call shoot
no_click:
mov si, offset player_x
mov di, offset player_y
call draw_player
call move_shot
mov ah, 01h
int 16h
jnz pressed
jz not_pressed
pressed:
mov ah, 0h
int 16h
mov [player_dir], al
call move_player
call draw_player
not_pressed:
mov si, offset cube1x
mov di, offset cube1y
call print_dot_from_memory
call print_cube
mov ax, [cube1dir]
call change_dir
call print_cube
mov si, offset cube2x
mov di, offset cube2y
call print_dot_from_memory
call print_cube
mov ax, [cube2dir]
call change_dir
call print_cube
mov si, offset cube3x
mov di, offset cube3y
call print_dot_from_memory
call print_cube
mov ax, [cube3dir]
call change_dir
call print_cube
mov si, offset cube4x
mov di, offset cube4y
call print_dot_from_memory
call print_cube
mov ax, [cube4dir]
call change_dir
call print_cube
mov si, offset cube5x
mov di, offset cube5y
call print_dot_from_memory
call print_cube
mov ax, [cube5dir]
call change_dir
call print_cube
mov si, offset cube6x
mov di, offset cube6y
call print_dot_from_memory
call print_cube
mov ax, [cube6dir]
call change_dir
call print_cube
mov si, offset cube7x
mov di, offset cube7y
call print_dot_from_memory
call print_cube
mov ax, [cube7dir]
call change_dir
call print_cube
jmp next
    ret
endp
proc random_x
push ax
push bx
push cx

mov ah, 0h
int 1ah
mov ax, dx
xor dx, dx
mov cx, 6
div cx
add dx, bx
cmp dx, 10h
je sub2
cmp dx, 09h
je sub1
jmp nosub
sub2:
sub dx, 02h
jmp nosub
sub1:
sub dx, 01h
jmp nosub
nosub:
pop cx
pop bx
pop ax
ret
endp
proc assign_random
call random_x
mov [di], dx


ret
endp
Start:
    mov ax, @data
    mov ds, ax

	mov si, offset array

	mov ax, [si]
	mov ax, 0
	mov ax, [si+4]

mov ax, 0000h
int 33h



mov di, offset cube1dir
mov bx, 1h
call assign_random
mov di, offset cube2dir
mov bx, 1h
call assign_random
mov di, offset cube3dir
mov bx, 1h
call assign_random
mov di, offset cube4dir
mov bx, 1h
call assign_random
mov di, offset cube5dir
mov bx, 1h
call assign_random
mov di, offset cube6dir
mov bx, 1h
call assign_random
mov di, offset cube7dir
mov bx, 1h
call assign_random


call color_pixel


Exit:
    mov ax, 4C00h
    int 21h
END start