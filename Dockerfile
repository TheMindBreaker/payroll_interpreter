FROM gcc:latest

RUN apt-get update && apt-get install -y flex bison

WORKDIR /usr/src/payroll_interpreter

COPY . /usr/src/payroll_interpreter

RUN yacc -d yacc.y && lex lex.l && gcc lex.yy.c y.tab.c -o payroll_interpreter

CMD ["./payroll_interpreter"]
