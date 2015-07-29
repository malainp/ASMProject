ESPERA MACRO Retraso    
    PUSH BX
    PUSH CX
	MOV bx,0000h
	MOV ch,0000h
	Retraso: 
	    INC BX
	    CMP BX,0FFFFh
	    JB  Retraso	
	    MOV BX,0000h
	    INC CX
	    CMP CX, 01FFh
	    JB Retraso
    POP CX
    POP BX
ENDM

MVIDEO MACRO
    MOV AX, 0013h
    INT 10h
ENDM                                 

PIXEL MACRO COLOR, X, Y  
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX    
    
    MOV AH, 0Ch
    MOV AL, COLOR
    MOV BH, 00h
    MOV CX, X
    MOV DX, Y
    INT 10h
    
    POP DX
    POP CX
    POP BX
    POP AX
ENDM   

DESPANTALLA MACRO LINEAS
    PUSH AX
    PUSH BX 
    PUSH CX
    MOV AH, 06h
    MOV AL, LINEAS
    MOV BH, NEGRO
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
    POP CX
    POP BX
    POP AX      
ENDM

IMPRIMIR MACRO MSG, COLOR, SIGCAR, TERMINADO
    PUSH AX 
    PUSH BX
    PUSH SI     
    LEA SI, MSG
    SIGCAR:  
        MOV AL, [SI]
        CMP AL, 0
        JZ  TERMINADO
        INC SI
        MOV AH, 0Eh
        MOV BL, COLOR
        INT 10h
        JMP SIGCAR
    TERMINADO:
        POP SI 
        POP BX
        POP AX    
ENDM

MOVER MACRO TECLA, ARRU1, ABAU1, IZQU1, DERU1, ARRU2, ABAU2, IZQU2, DERU2, DIRECCION1, DIRECCION2, NADA
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    CMP TECLA, 11h; 'W'
    JE  ARRU1       
    CMP TECLA, 1Fh; 'S'
    JE  ABAU1
    CMP TECLA, 1Eh; 'A'
    JE  IZQU1
    CMP TECLA, 20h; 'D'
    JE  DERU1
     
    CMP TECLA, 17h ;'I'
    JE  ARRU2
    CMP TECLA, 25h ;'K'
    JE  ABAU2
    CMP TECLA, 24h;'J'
    JE  IZQU2
    CMP TECLA, 26h;'L'
    JE  DERU2
    JMP NADA
    ARRU1:
        DEC _yUsr1    
        JMP DIRECCION1
    ABAU1:
        INC _yUsr1
        JMP DIRECCION1
    IZQU1:
        DEC _xUsr1
        JMP DIRECCION1
    DERU1:
        INC _xUsr1
        JMP DIRECCION1        
                
    ARRU2:
        DEC _yUsr2
        JMP DIRECCION2
    ABAU2:
        INC _yUsr2
        JMP DIRECCION2
    IZQU2:
        DEC _xUsr2
        JMP DIRECCION2
    DERU2:
        INC _xUsr2
        JMP DIRECCION2
    
    DIRECCION1:  
        MOV AH, TECLA
        MOV _ulTeclaU1, AH
        JMP NADA
    DIRECCION2:         
        MOV AH, TECLA
        MOV _ulTeclaU2, AH
        JMP NADA
    
    ;SI NO PASA NADA
    NADA:           
    
    POP DX
    POP CX
    POP BX
    POP AX
ENDM

ACTTECLA MACRO TECLA
    CMP TECLA, 11h; 'W'
    JE  ARRU1       
    CMP TECLA, 1Fh; 'S'
    JE  ABAU1
    CMP TECLA, 1Eh; 'A'
    JE  IZQU1
    CMP TECLA, 20h; 'D'
    JE  DERU1
     
    CMP TECLA, 17h ;'I'
    JE  ARRU2
    CMP TECLA, 25h ;'K'
    JE  ABAU2
    CMP TECLA, 24h;'J'
    JE  IZQU2
    CMP TECLA, 26h;'L'
    JE  DERU2
    JMP NADA   
    
    ARRU1:  
        JMP DIRECCION1
    ABAU1:
        JMP DIRECCION1
    IZQU1:
        JMP DIRECCION1
    DERU1:
        JMP DIRECCION1        
                
    ARRU2:
        JMP DIRECCION2
    ABAU2:
        JMP DIRECCION2
    IZQU2:
        JMP DIRECCION2
    DERU2:
        JMP DIRECCION2
    
    DIRECCION1:  
        MOV AH, TECLA
        MOV _ulTeclaU1, AH
        JMP NADA
    DIRECCION2:         
        MOV AH, TECLA
        MOV _ulTeclaU2, AH
        JMP NADA
    
    ;SI NO PASA NADA
    NADA:           
    
ENDM

TOPES MACRO X, Y, SALE, N, CHOCA, NC, ESTADO  
    PUSH AX        
    PUSH BX
    PUSH CX
    PUSH DX
    CMP X, 0
    JB SALE
    CMP X, 319
    JA SALE
    CMP Y, 0
    JB SALE
    CMP Y, 199
    JA SALE
    JMP N
    SALE:
        CALL CRK
        
    N:     
        MOV AH, 0Dh  
        MOV BH, 00h
        MOV CX, X
        MOV DX, Y
        INT 10h
        
        CMP AL, 00h
        JNE CHOCA
        
        JMP NC
        
        
        CHOCA:
            MOV ESTADO, 01h
            JMP NC
    NC:
    
    POP DX
    POP CX 
    POP BX    
    POP AX
ENDM                

BORDES MACRO 
    MOV SI, 00h
    BARRIBA:
        MOV AH, 0Ch
        MOV AL, KEVIN
        MOV BH, 00h
        MOV CX, SI
        MOV DX, 0000h
        INT 10h
        INC SI  
        CMP SI, 13Fh
        JB  BARRIBA
    MOV SI, 00h
    BABAJO:
        MOV AH, 0Ch
        MOV AL, KEVIN
        MOV BH, 00h
        MOV CX, SI
        MOV DX, 199
        INT 10h
        INC SI  
        CMP SI, 13Fh
        JB  BABAJO    
    MOV SI, 00h
    BIZQUIERDA:
        MOV AH, 0Ch
        MOV AL, KEVIN
        MOV BH, 00h
        MOV CX, 0000h
        MOV DX, SI
        INT 10h
        INC SI  
        CMP SI, 199
        JB  BIZQUIERDA
    MOV SI, 00h                                  
    BDERECHA:
        MOV AH, 0Ch
        MOV AL, KEVIN
        MOV BH, 00h
        MOV CX, 13Fh
        MOV DX, SI
        INT 10h
        INC SI  
        CMP SI, 199
        JB  BDERECHA
ENDM                                                    

.MODEL SMALL
.STACK 100h                               
.DATA               
    ;---------------------------------------VARIABLES DE CONTROL------------------------------------------
    ;Estas dos variables almacenan la ultima tecla presionada por el jugador. 
    ;si el jugador no presiona o presiona una tecla no valida la variable se
    ;usa para dirigir el siguiente movimiento del usuario. 
    _ulTeclaU1      DB      1Eh ;E     
    _ulTeclaU2      DB      26h ;L     
    
    ;Estos dos pares de variables almacenan la posicion actual de cada jugador
    _xUsr1          DW      009Fh; 159
    _yUsr1          DW      0064h; 100
    
    _xUsr2          DW      00A1h; 161
    _yUsr2          DW      0064h; 100                                 
    
    ;Estas dos variables almacenan el estado de vida de ambos jugadores. Cuando
    ;una variable se eleva a 01h significa que el jugador se ha estrellado
    _estadoTRON     DW      00h
    _estadoCLU      DW      00h
    ;------------------------------------------------------------------------------------------------------               
               
    ;----------------------------------------------COLORES-------------------------------------------------
    KEVIN   EQU     1Fh ;BLANCO
    CLU     EQU     2Ch ;AMARILLO
    TRON    EQU     20h ;AZUL
    RINZLER EQU     28h ;ROJO
    NEGRO   EQU     00h ;NEGRO           
    ;------------------------------------------------------------------------------------------------------    
    
    ;------------------------------------------CADENAS VARIAS----------------------------------------------
    
    _db_datos       DB      'Instituto Tecnologico de la Laguna',13,10
                    DB      'Ing. Sistemas Computacionales',13,10
                    DB      'Lenguajes de interfaz',13,10
                    DB      'Periodo Verano 2015',13,10
                    DB      'Misael Alain Peralta Velazquez',13,10
                    DB      '11130526',13,10
                    DB      'Proyecto final',13,10,13,10,0                                                                  
                                                                  
    _db_descrip     DB      'Bienvenidos a la red.',13,10
                    DB      'Se jugara una ronda de motos de luz.',13,10
                    DB      'Se enfrentan:',13,10
                    DB      'programa TRON vs programa CLU', 13,10
                    DB      'Las reglas son:',13,10
                    DB      'Un pograma debe hacer que el otro se estrelle con una estela de luz.',13,10
                    DB      'El programa que quede en pie gana.',13,10, 0
                    
    _db_descTRON    DB      'Jugador uno (AZUL - TRON) use:',13,10
                    DB      'W - Arriba',13,10
                    DB      'S - Abajo',13,10
                    DB      'A - Izquierda',13,10
                    DB      'D - Derecha',13,10, 0
                    
    _db_descCLU     DB      'Jugador dos (AMARILLO - CLU) use:',13,10
                    DB      'I - Arriba',13,10
                    DB      'K - Abajo',13,10
                    DB      'J - Izquierda',13,10
                    DB      'L - Derecha',13,10, 0
    
    _db_prestecla   DB      'Presione una tecla para continuar...',13,10,0                                 
    
    _db_chocaTRON   DB      'TRON se ha estrellado, CLU gana!!',13,10,0
    
    _db_chocaCLU    DB      'CLU se ha estrellado, TRON gana!!',13,10,0
    
    _db_esperaEnter DB		'Presione enter para salir...',13,10,0
	
    ;-------------------------------------------------------------------------------------------------------                
.CODE
    INICIO:
        MOV AX, @Data                              
        MOV DS, AX                          

        MVIDEO
        
        IMPRIMIR _db_datos      KEVIN   SIGCAR0 TERMINADO0
        
        CALL RK
        
        IMPRIMIR _db_descrip    KEVIN   SIGCAR  TERMINADO
        IMPRIMIR _db_descTRON   TRON    SIGCAR2 TERMINADO2
        IMPRIMIR _db_descCLU    CLU     SIGCAR3 TERMINADO3
        IMPRIMIR _db_prestecla  KEVIN   SIGCAR4 TERMINADO4     
                
        CALL RK
        
        DESPANTALLA 00h
                   
        BORDES                   
        ;ENTRADA AL JUEGO
        JUEGO:    
            TOPES _xUsr1 _yUsr1 SALEU1 Na1 CHO1 NC1 _estadoTRON
            CMP _estadoTRON, 01h
            JE  PIERDETRON
            
            PIXEL   TRON    _xUsr1  _yUsr1         
            
            TOPES _xUsr2 _yUsr2 SALEU2 Na2 CHO2 NC2 _estadoCLU
            CMP _estadoCLU, 01h
            JE  PIERDECLU
            PIXEL   CLU     _xUsr2  _yUsr2
                        
            ESPERA R2
            ESPERA RR2
            
            MOV AH, 01h
            INT 16h
            JZ  NHAYTECLA
            JNZ HAYTECLA 
                
            JMP JUEGO
            
            HAYTECLA:
                ACTTECLA AH
                MOV AH, 00h
                INT 16h
                         
            NHAYTECLA:
                MOV AH, _ulTeclaU1
                MOVER AH ARU12 ABU12 IZU12 DEU12 ARU22 ABU22 IZU22 DEU22 D12 D22 N12
                MOV AH, _ulTeclaU2
                MOVER AH ARU13 ABU13 IZU13 DEU13 ARU23 ABU23 IZU23 DEU23 D13 D23 N13
                JMP JUEGO
            
            PIERDETRON:
                DESPANTALLA 00h
                IMPRIMIR _db_chocaTRON CLU SIGCAR5 TERMINADO5
                ;CALL CRK
                JMP SALIR
            PIERDECLU:
                DESPANTALLA 00h
                IMPRIMIR _db_chocaCLU TRON SIGCAR6 TERMINADO6               
                ;CALL CRK
                JMP SALIR
        
		SALIR:
			IMPRIMIR _db_esperaEnter	KEVIN	SIGCAR7	TERMINADO7
			CALL WFE              
        ;CALL CRK
			
	WFE PROC NEAR
		ENT:
			MOV AH, 08h
			INT 21h
			CMP AL, 0Dh
			JNE ENT 
			MOV AX, 4C00h
			INT 21h
			RET
	ENDP
    RK PROC NEAR
        MOV AH, 08h
        INT 21h 
        RET
    ENDP        
    CRK PROC NEAR
        MOV AH, 08h
        INT 21h
        MOV AX, 4C00h
        INT 21h
        RET
    ENDP                        
    END INICIO               
    