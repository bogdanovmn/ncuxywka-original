package Psy::Text::Bot::Lexicon;

use strict;
use warnings;
use utf8;

require Exporter;
our @ISA = qw|Exporter|;
our @EXPORT = qw|
	@CREO_COMMENT_TEMPLATE
	@GB_COMMENT_TEMPLATE
	%TEMPLATE_WORDS
|;

our @CREO_COMMENT_TEMPLATE = (
'#WHO# с #THAN# устроили пьяный дебош #HOSPITAL_PLACE#. Они кричат: "#RESUME#"',
'#WHO# не умеют летать выше пяти тысяч метров! Пользуйтесь #THAN#...',
'Минздрав предупреждает: #WHO# не являются #THAN#. Не пытайтесь называть их чужими именами. #RESUME#',
'Помните, #TERM# - это залог успеха на пути самосовершенствования. Заведите себе побольше их. #RESUME#',
'#BODY_WHERE# обнаружен #BODY_ILLNESS#. Ой, не у вас, это просто перед вами сдавали анализы #WHO#.',
'Спящие не могут сопротивлятся насилию. Их сторожат #WHO#.',
'В мире постоянно погибают #WHO#. #RESUME#',
'Последнее время #HOSPITAL_PLACE# наблюдаются острые вспышки шизофрении. Людям кажется, что у них #TERM#. #RESUME#',
#'subject любят object. Доказано НИИ РАМН somethings1 object',
#'object лечат только subject. Ничего кроме! Ничего, ничего, ничего!.. Ну, может только object.',
#'Вы благополучно доехали на кровати до object. Слезайте, а не то придут object... и санитары.',
#'Вы упали прямо на object. Смотрите не раздовите, а не то subject обидется.',
#'А вы знали, что subject не очень то любят object. Так то!',
#'Что вы говорите! Object прямо таки и ушёл от нас!...',
#'Ви почему это спрашиваете, ви что думаете, вокруг вас subject?',
#'Нет. Нет. Нет. Object нельзя истребить! Они часть етой голактеки!',
#'Ви что, дебил? Идите сдавать анализы! Вас subject ждут!',
#'Проходите, проходите, subject тоже люди. Они тоже хотят object.',
#'На улице наблюдаются лёгкие something1. Уберегите ваших object от этого кошмара!',
#'Да ну, вы что не видели subject? Ви что, в лесу живёте?!..',
#'Object надо любить. Их едят subject.',
#'Я ещё вернусь, и со мной придут мои верные subject. И я устрою вам множественные something1.'
);

our @GB_COMMENT_TEMPLATE = (
'#ADJECTIVE# #POSITION#'
);

our %TEMPLATE_WORDS = (

HOSPITAL_PLACE => [
	'в палате №6',
	'в процедурной',
	'в регистратуре',
	'в палатах',
	'в кабинете главврача',
	'в кабинете медперсонала'
	],

WHO => [qw|
	коровы лошадки ослики слоники ёжики червячки суслики бобры ленивцы алкаши тунеядцы конфетки
	обезьяны дубы каштаны сверчки таракашки жучки паучки бабочки цветы трупы клёны машины
	роботы компьютеры начальники шизики
	|],

THAN => [qw|
	табуретками чайниками люстрами утюгами автомобилями унитазами зайцами лягушками крокодилами
	раскладушками санитарами
|],

BODY_WHERE => [
	'в вашей крови',
	'в вашей печени', 
	'в вашей нервной системе',
	'на ваших волосах',
	'под вашей правой коленкой',
	'за вашей спиной',
	'между вашими ягодицами',
	'под вашими ногтями',
	'в вашем желудке',
	'у вас в коре головного мозга'
],

BODY_ILLNESS => [
	'кариес',
	'понос',
	'бешенный зуд',
	'остеохондроз',
	'радикулит',
	'насморк',
	'геморрой',
	'олигофренизм',
	'ревматизм'
],

TERM => [qw|
	императив вивисекция аллегория аллитерация ассонанс категория дизъюнкция конъюнкция интеграл
	интрузия дифляция дефлорация эмансипация ингаляция прострация когнитивность диссонанс
	турбулентность гиперактивность перетрубация
|],

RESUME => [
	'Желаем приятного аппетита!',
	'Смотрите не подавитесь!',
	'Подвиньтесь, я встану!',
	'Мы тоже кролики!',
	'А разве не так?',
	'Ешьте, не обляпайтесь!',
	'Минздрав убедительно предупреждает!',
	'Кто говорит? - Администрация так говорит',
	'Так точно!',
	'Бойтесь педиатров',
	'Бойтесь стоматологов',
	'Бойтесь живодёров',
	'Любите санитаров',
	'Любите любить',
	'Любите любить любить',
	'Любите любить любить любить',
	'Плодитесь и размножайтесь!',
	'Мойте руки перед едой!',
	'Всему виной коммунизм!'
	],

ADJECTIVE => [ qw|
	упрямый вспыльчивый неугомонный противоречивый радостный грустный веселый смурной грозный хитрый
	агрессивный любопытный пассивный любознательный смущенный развратный тайный нищий удачливый
	красивый мудрый страшный пугающий милосердный честный счастливый очаровательный спящий прыгающий
	коварный забытый пропавший прячущийся дружелюбный проклятый жестокий
|],

POSITION => [qw|
	пациэнт гражданин робот призрак обыватель домовой леший доктор мушкетер трубочист весельчак
	нигилист коммунист фашист антифашист живодер краб шмель разбойник партизан паромщик свидетель
	прохожий сектант эпилептик вегетарианец парашютист шахтер сантехник кинорежиссер каратист
	шпалоукладчик почтальон мясник библиотекарь бизнесмен пивовар калека пенсионер рабочий военный
	бухгалтер парикмахер
|]

);
