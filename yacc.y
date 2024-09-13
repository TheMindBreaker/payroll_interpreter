%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* name;
    int id;
    int salary;
} Employee;

Employee employees[100];
int employee_count = 0;

const int REGULAR_HOURS = 40;
const float TAX_RATE = 0.16;
const float RETENTION_RATE = 0.02;
const float IMS_RET = .265;

void add_employee(char* name, int id, int salary) {
    employees[employee_count].name = strdup(name);
    employees[employee_count].id = id;
    employees[employee_count].salary = salary;
    employee_count++;
}

void print_employees() {
    if (employee_count == 0) {
        printf("No hay empleados registrados.\n");
    } else {
        for (int i = 0; i < employee_count; i++) {
            printf("Empleado: %s, ID: %d, Salario: %d\n", employees[i].name, employees[i].id, employees[i].salary);
        }
    }
}

void calculate_payroll_all(int days) {
    printf("Cálculo de nómina para todos los empleados por %d días:\n", days);
    for (int i = 0; i < employee_count; i++) {
        int extra_hours;
        printf("Ingrese las horas extras trabajadas por el empleado %s (ID: %d): ", employees[i].name, employees[i].id);
        scanf("%d", &extra_hours);

        int base_salary = employees[i].salary;
        int extra_pay = (base_salary / REGULAR_HOURS) * extra_hours * 2;  // Extra hours paid double
        int total_pay_before_taxes = base_salary + extra_pay;

        float taxes = total_pay_before_taxes * TAX_RATE;
        float retention = total_pay_before_taxes * RETENTION_RATE;
        float ims = base_salary * IMS_RET;
        float total_pay = total_pay_before_taxes - taxes - retention - ims;

        printf("Empleado: %s, ID: %d\n", employees[i].name, employees[i].id);
        printf("  Pago Regular: %d\n", base_salary);
        printf("  Pago Extra (por %d horas extras): %d\n", extra_hours, extra_pay);
        printf("  Impuestos (16%%): %.2f\n", taxes);
        printf("  Retención (2%%): %.2f\n", retention);
        printf("  IMS (26.5%%): %.2f\n", ims);
        printf("  Total a pagar: %.2f\n\n", total_pay);
    }
}

void calculate_payroll_employee(int id, int days) {
    int found = 0;
    for (int i = 0; i < employee_count; i++) {
        if (employees[i].id == id) {
            found = 1;
            int extra_hours;
            printf("Ingrese las horas extras trabajadas por el empleado %s (ID: %d): ", employees[i].name, id);
            scanf("%d", &extra_hours);

            int base_salary = employees[i].salary;
            int extra_pay = (base_salary / REGULAR_HOURS) * extra_hours * 2;
            int total_pay_before_taxes = base_salary + extra_pay;

            float taxes = total_pay_before_taxes * TAX_RATE;
            float retention = total_pay_before_taxes * RETENTION_RATE;
            float ims = base_salary * IMS_RET;
            float total_pay = total_pay_before_taxes - taxes - retention - ims;

            printf("Cálculo de nómina para empleado %s, ID: %d por %d días:\n", employees[i].name, id, days);
            printf("  Pago Regular: %d\n", base_salary);
            printf("  Pago Extra (por %d horas extras): %d\n", extra_hours, extra_pay);
            printf("  Impuestos (16%%): %.2f\n", taxes);
            printf("  Retención (2%%): %.2f\n", retention);
            printf("  IMS (26.5%%): %.2f\n", ims);
            printf("  Total a pagar: %.2f\n", total_pay);
            break;
        }
    }
    if (!found) {
        printf("Empleado con ID %d no encontrado.\n", id);
    }
}

void save_employees_to_file(const char* filename) {
    FILE* file = fopen(filename, "w");
    if (!file) {
        printf("Error al abrir el archivo para guardar.\n");
        return;
    }
    
    for (int i = 0; i < employee_count; i++) {
        fprintf(file, "%s %d %d\n", employees[i].name, employees[i].id, employees[i].salary);
    }
    
    fclose(file);
    printf("Empleados guardados exitosamente en el archivo '%s'.\n", filename);
}

void load_employees_from_file(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        printf("Error al abrir el archivo para cargar.\n");
        return;
    }
    
    employee_count = 0;  // Clear the current list before loading
    char name[100];
    int id, salary;
    
    while (fscanf(file, "%s %d %d", name, &id, &salary) != EOF) {
        add_employee(strdup(name), id, salary);
    }
    
    fclose(file);
    printf("Empleados cargados exitosamente desde el archivo '%s'.\n", filename);
}

int yylex();
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%union {
    int ival;
    char* sval;
}

%token EMPLOYEE ID SALARY LIST PAYROLL_ALL PAYROLL_EMPLOYEE SAVE LOAD
%token <ival> NUMBER
%token <sval> IDENTIFIER

%%

input:
    | input command
    ;

command:
    employee
    | LIST { print_employees(); }
    | PAYROLL_ALL NUMBER { calculate_payroll_all($2); }
    | PAYROLL_EMPLOYEE NUMBER NUMBER { calculate_payroll_employee($2, $3); }
    | SAVE IDENTIFIER { save_employees_to_file($2); }
    | LOAD IDENTIFIER { load_employees_from_file($2); }
    ;

employee:
    EMPLOYEE IDENTIFIER ID NUMBER SALARY NUMBER
    {
        add_employee($2, $4, $6);
    }
    ;

%%

int main() {
    printf("Ingrese la información de los empleados o use 'LIST', 'PAYROLL_ALL <días>', 'PAYROLL_EMPLOYEE <ID> <días>', 'SAVE <archivo>', o 'LOAD <archivo>':\n");
    yyparse();
    return 0;
}
