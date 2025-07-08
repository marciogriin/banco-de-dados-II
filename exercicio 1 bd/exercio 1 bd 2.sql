create database escola;
use escola;
create table alunos(
id int not null auto_increment,
nome varchar(30) not null,
nota1 decimal (3,2),
nota2 decimal (3,2),
primary key (id)
) default charset utf8mb4;

insert into alunos (nome, nota1, nota2) values
('joao', 7.0, 8.0),
('pedro', 9.0, 9.8),
('mario', 6.0, 8.0),
('eduardo', 10.0, 9.0);

create view alunos_com_media as 
select
	id,
	nome,
	nota1,
	nota2,
	(nota1 + nota2) / 2 as media,
	case
		when (nota1 + nota2) / 2 >= 7 then 'APROVADO'
        else 'REPROVADO'
	end as situacao
from alunos;

select * from alunos_com_media;

create view vw_aprovados as
select * from alunos_com_media
where situacao = 'APROVADO';

select * from vw_aprovados;

DELIMITER $$
CREATE trigger tg_verificar_notas_inseridas_depois
before insert on alunos
for each row
begin
	if new.nota1 < 0 or new.nota1 > 10 or new.nota2 < 0 or new.nota2 > 10 then
		signal sqlstate '45000'
		set message_text = ' as notas devem estar entre 0 e 10';
	end if;
end $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE calcular_media_geral()
BEGIN
  DECLARE media_geral DECIMAL(5,2);
  
  SELECT AVG((nota1 + nota2) / 2) INTO media_geral FROM alunos;
  
  SELECT CONCAT('A média geral da turma é: ', media_geral) AS resultado;
END $$

DELIMITER ;
CALL calcular_media_geral();




