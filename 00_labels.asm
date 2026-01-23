.const PIPPO=1
.var PLUTO=2
.label A=$FF
.label explicitLabel=$2000
implicitLabel: .byte $BE, $EF, $AA, A, PLUTO

.for (var i = 0; i < 5; i++) {
    .byte i * 10
}
    

// Per KickAssembler sono entrambe label, ecco il sym:

//      .label A=$ff
//      .label explicitLabel=$2000
//      .label implicitLabel=$2000

// ma A diventa un alias per $FF, explicitLabel alias per $2000
// mentre veraLimplicitLabelabel diventa un alias per l'address 
// di dove si trova, quindi sempre $2000, che è l'offset
// a questo servono i primi 2 byte, è l'offset del programma in
// memoria

// Le label sono solo simboli per l'assembler:
// In memoria c'è solo: 00 20 BE EF AA FF.
