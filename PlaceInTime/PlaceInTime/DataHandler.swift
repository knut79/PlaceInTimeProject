//
//  PopulateData.swift
//  TimeIt
//
//  Created by knut on 18/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import CoreData
import UIKit





class DataHandler
{
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var historicEventItems:[HistoricEvent]!
    var todaysYear:Double!
    init()
    {
        loadGameData()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Year, fromDate: date)
        todaysYear = Double(components.year)
        historicEventItems = []
    }
    
    func populateData(completePopulating: (() -> (Void))?)
    {
        
        
        var id = 1
        
        //MISCELLANEOUS ,tags:"#miscellaneous"
        
        newEvent(id++,title:"First Olympiad in Greece", year:-776,level:2,tags:"#miscellaneous#sport")
        newEvent(id++,title:"Aesop’s fables thought to be written", year:-990,tags:"#miscellaneous")
        
        newEvent(id++,title:"Buddha born in India.", year:-563,tags:"#miscellaneous")
        newEvent(id++,title:"Confucius born in China", year:-551,tags:"#miscellaneous")
        newEvent(id++,title:"Rome as a Republic founded", year:-500, text:"End of monarchy in Rome", level:1, tags:"#miscellaneous")
        newEvent(id++,title:"Socrates drink hemlock", year:-399, text:"Socrates is required to drink hemlock to end his life after being found guilty of corrupting the youth of Athens",level:2,tags:"#miscellaneous")
        //_?newEvent(id++,title:"Persian empire", from:-550 , to:-330,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Livius Andronicus is the first Roman poet", year:-240,tags:"#miscellaneous")
        newEvent(id++,title:"Solomon builds the Temple in Jerusalem", year:-950,tags:"#miscellaneous")
        newEvent(id++,title:"Founding of Constantinople", year:330,tags:"#miscellaneous")
        newEvent(id++,title:"Library of Alexandria is destroyed by fire", year:391,tags:"#miscellaneous")
        newEvent(id++,title:"Muhammad the Prophet dies", year:632,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Vikings settle in Iceland", year:874,tags:"#miscellaneous")
        //_?newEvent(id++,title:"The Capetian dynasty", from:987 , to:1328,tags:"#miscellaneous")
        newEvent(id++,title:"Knights Templar Order established in Jerusalem", year:1119,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Moscow built by Prince Yuri Dolgoruky", year:1147)
        newEvent(id++,title:"The temple complex of Angkor Wat built", year:1150,level:2, text:"Built by King Suryavarman II in Kampuchea (formerly Cambodia).",tags:"#miscellaneous")
        newEvent(id++,title:"Construction of the Leaning Tower of Pisa begins", year:1173,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"The Louvre Museum in Paris built as a fortress", year:1190,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Magna Carta signed by King John", year:1215,text:"The Great Charter, or Magna Carta, limiting royals power, signed and sealed by King John of England on 15 June at Runnymede, west of London near what is now Windsor. The Fourth Lateran Council recognized the doctrine of transubstantiation by which the bread and wine of the church service were seen as Christ’s flesh and blood.",level:1,tags:"#miscellaneous")
        newEvent(id++,title:"The Inquisition begins", year:1233,level:2,tags:"#miscellaneous")
        
        newEvent(id++,title:"Leaning Tower of Pisa completed", year:1360,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Joan of Arc born in France.", year:1412,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Michelangelo Buonarroti born", year:1475,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"World population 400 million", year:1500,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Martin Luther begins the Reformation", year:1517,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"The Union Jack adopted in England", year:1606,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"First permanent English colony on American mainland", year:1607,text:"Jamestown, Virginia established, first permanent English colony on American mainland.",level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Buildig of Taj Mahal started", year:1632,level:1,tags:"#miscellaneous")
        
        newEvent(id++,title:"Descartes publishes Principles of Philosophy", year:1644,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"World population 700 million", year:1700,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Act of Settlement in England", year:1701,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Act of Union between Scotland and England, creating Great Britain", year:1707,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Daniel Defoe publishes Robin Crusoe", year:1719,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"South Sea Bubble", year:1720,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Mozart tours Europe as 6-year-old prodigy", year:1762,tags:"#miscellaneous")
        newEvent(id++,title:"Stamp Act passed in Britain", year:1765,tags:"#miscellaneous")
        newEvent(id++,title:"Boston Tea Party act", year:1769,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"The United Colonies changes name to The United States", year:1774,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Declaration of Independence by American colonies", year:1776,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"The first US presidential election under the Constitution", year:1789,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"US Post Office established", year:1789,tags:"#miscellaneous")
        
        newEvent(id++,title:"The population of the world is about one billion", year:1800,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"First Oktoberfest", year:1810,text:"Held in Bavaria as celebration of Ludwig I’s wedding on 27 October",tags:"#miscellaneous")
        newEvent(id++,title:"Rabbits introduced to Australia", year:1850,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Kingdom of Italy declared", year:1861,tags:"#miscellaneous")
        newEvent(id++,title:"Red Cross established", year:1864,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"US abolishes slavery through the Thirteenth Amendment", year:1865,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Karl Marx publishes Das Kapital", year:1867,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"German Empire created at Versailles", year:1871,tags:"#miscellaneous")
        newEvent(id++,title:"Leo Tolstoy writes Anna Karenina", year:1871,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Victor Hugo published Les Miserables", year:1874,tags:"#miscellaneous")
        newEvent(id++,title:"Coca-Cola label registered", year:1887,tags:"#miscellaneous")
        newEvent(id++,title:"The Eiffel Tower raised", year:1889,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"New Zealand first country to give women the right to vote", year:1893,tags:"#miscellaneous")
        newEvent(id++,title:"World’s first minimum wage law", year:1894,text:"New Zealand passes world’s first minimum wage law",tags:"#miscellaneous")
        newEvent(id++,title:"First Tour de France", year:1903,level:2,tags:"#miscellaneous#sport")
        newEvent(id++,title:"Harley-Davidson motorcycle company founded", year:1903,tags:"#miscellaneous")
        newEvent(id++,title:"Republic of China founded", year:1910,tags:"#miscellaneous")
        newEvent(id++,title:"The Titanic sinks", year:1912,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"BMW founded", year:1917,tags:"#miscellaneous")
        newEvent(id++,title:"First non-stop flight across the Atlantic", year:1919,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"First Winter Olympics at Chamonix", year:1924,level:1,tags:"#miscellaneous#sport")
        newEvent(id++,title:"Charles Lindbergh flies non-stop from New York to Paris", year:1927,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"New York Stock Exchange crash (not blackmonday)", year:1929,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"First football World Cup", year:1930,level:1,tags:"#miscellaneous#sport")
        //_?newEvent(id++,title:"Prohibition in the United States", from:1920, to:1933,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Start of Prohibition in the United States", year:1920,level:2,tags:"#miscellaneous")
        
        newEvent(id++,title:"Golden Gate Bridge opens", year:1937,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Israel established", year:1948,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"NATO founded", year:1949,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Republic of Ireland founded", year:1949,tags:"#miscellaneous")
        newEvent(id++,title:"The first Emmy is awarded", year:1949,tags:"#miscellaneous")
        newEvent(id++,title:"Playboy magazine is launched", year:1953,tags:"#miscellaneous")
        newEvent(id++,title:"The Beatles form", year:1959,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"The Cuban crisis", year:1962,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Che Guevara is shot dead by Bolivian troops", year:1967,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"First staging of the Superbowl", year:1967,tags:"#miscellaneous#sport")
        newEvent(id++,title:"Dr Martin Luther King assassinated", year:1968,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Watergate scandal", year:1973,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Arab oil embargo brings Europe to its knees", year:1973,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Apple computers founded", year:1976,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Firts Star Wars film premiers", year:1977,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Nuclear accident at Three Mile Island, Pennsylvania", year:1979,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"John Lennon is shot by Mark Chapman", year:1980,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"PacMan hits the arcades", year:1981,tags:"#miscellaneous")
        newEvent(id++,title:"Nuclear reactor explodes in Chernobyl, Ukraine", year:1986,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"World population reaches 5 billion", year:1987,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Stock exchanges collapse on Black Monday", year:1987,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Exxon Valdes runs aground in Alaska", year:1989,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Berlin Wall comes down", year:1989,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"End of the Soviet Union", year:1991,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"World population reaches the 6 billion mark", year:1999,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"September 11", year:2001,level:1,tags:"#miscellaneous")
        newEvent(id++,title:"Euro banknotes and coins released", year:2002,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Arnold Schwarzenegger voted Governor of California", year:2003,level:2,tags:"#miscellaneous")
        newEvent(id++,title:"Concorde makes its last commercial flight", year:2003,level:2,tags:"#miscellaneous")
        //_?newEvent(id++,title:"The plague of Europe", from:542, to:593,tags:"#miscellaneous")
        
        //SPORT
        newEvent(id++,title:"Chariot racing becomes an event of the Olympic games", year:-680,tags:"#sport")
        newEvent(id++,title:"King Henry VIII of England orders bowling lanes at Whitehall", year:1520,tags:"#sport")
        newEvent(id++,title:"First recorded boxing match", year:1681,level:2,tags:"#sport")
        newEvent(id++,title:"The game of Billiards is mentioned in the New England Courant", year:1722,tags:"#sport")
        newEvent(id++,title:"First international boxing match", year:1733,level:2,tags:"#sport")
        newEvent(id++,title:"The first cricket match is played in America", year:1751,tags:"#sport")
        newEvent(id++,title:"Tennis is first mentioned in an English sporting magazine", year:1793,tags:"#sport")
        newEvent(id++,title:"First Women's Golf Tournament is held", year:1811,tags:"#sport")
        newEvent(id++,title:"Two English boxers are first to use padded gloves.", year:1818,tags:"#sport")
        newEvent(id++,title:"R J Tyers patents roller skates", year:1823,tags:"#sport")
        newEvent(id++,title:"First baseball game played in America", year:1839,level:2,tags:"#sport")
        newEvent(id++,title:"First baseball team, New York Knickerbockers organize,", year:1845,level:1,tags:"#sport")
        newEvent(id++,title:"World's first soccer club, Sheffield F.C. is founded", year:1857,level:1,tags:"#sport")
        newEvent(id++,title:"First US billiards championship is held in Detroit", year:1858,tags:"#sport")
        newEvent(id++,title:"The bowling ball is invented", year:1862,tags:"#sport")
        newEvent(id++,title:"Dr James Moore wins first recorded bicycle race", year:1868,level:2,tags:"#sport")
        newEvent(id++,title:"Cincinnati Red Stockings become the first professional baseball team", year:1869,tags:"#sport")
        newEvent(id++,title:"British Rugby Union forms", year:1871,tags:"#sport")
        newEvent(id++,title:"First international rugby game. Scotland 1, England 0", year:1871,tags:"#sport")
        newEvent(id++,title:"First recorded hockey game", year:1875,level:2,tags:"#sport")
        newEvent(id++,title:"Matthew Webb becomes first to swim English Channel ", year:1875,level:1,tags:"#sport")
        newEvent(id++,title:"John T Reid opens first US golf course", year:1889,tags:"#sport")
        
        newEvent(id++,title:"Veterans in the USA establish the National Rifle Association", year:1871,level:1,tags:"#sport")
        newEvent(id++,title:"The first competitive event for cars, from Paris to Rouen", year:1894,tags:"#sport")
        newEvent(id++,title:"The first modern Olympic Games are held in Athens", year:1896,level:1,tags:"#sport")
        newEvent(id++,title:"The first Grand Prix of motor-racing is held near Le Mans", year:1906,level:1,tags:"#sport")
        newEvent(id++,title:"US boxer Jack Johnson becomes the first black heavyweight champion", year:1908,level:1,tags:"#sport")
        newEvent(id++,title:"Ray Harroun wins the first Indianapolis 500 motor race", year:1911,level:1,tags:"#sport")
        newEvent(id++,title:"George Ruth acquires the nickname Babe", year:1914,level:2,tags:"#sport")
        newEvent(id++,title:"Boston Red Sox sell Babe Ruth to the New York Yankees", year:1919,tags:"#sport")
        newEvent(id++,title:"Melbourne hosts the Olympics", year:1956,tags:"#sport")
        newEvent(id++,title:"8 members of Manchester U. football team die in an air crash", year:1958,level:2,tags:"#sport")
        newEvent(id++,title:"Joe Frazier becomes the first boxer to beat Muhammad Ali", year:1971,level:1,tags:"#sport")
        newEvent(id++,title:"Niki Lauda wins the first of three Formula One world championship", year:1971,tags:"#sport")
        newEvent(id++,title:"Björn Borg wins his first title at Wimbledon", year:1976,level:2,tags:"#sport")
        newEvent(id++,title:"Magic Johnson begins 12 years with the Los Angeles Lakers", year:1980,tags:"#sport")
        newEvent(id++,title:"Carl Lewis wins four gold medals at the Los Angeles Olympics", year:1984,level:1,tags:"#sport")
        newEvent(id++,title:"Kasparov defeats Karpov becoming world champion in chess", year:1985,level:2,tags:"#sport")
        newEvent(id++,title:"Soccer World Cup held in Mexico", year:1986,level:1,tags:"#sport")
        newEvent(id++,title:"Ayrton Senna dies during the San Marino Grand Prix", year:1994,level:1,tags:"#sport")
        newEvent(id++,title:"Schumacher wins his first world championship title in Formula One", year:1994,level:1,tags:"#sport")
        newEvent(id++,title:"Lance Armstrong wins his first Tour de France", year:1999,level:1,tags:"#sport")
        newEvent(id++,title:"Olympics banned by the Roman Emperor Theodosius", year:-394,tags:"#sport")
        newEvent(id++,title:"The International Olympic Committee (IOC) founded ", year:1894,level:2,tags:"#sport")
        newEvent(id++,title:"Women competed for the first time at the Olympic games", year:1900,level:2,tags:"#sport")
        newEvent(id++,title:"Second Winter Olympics held in St Moritz", year:1928,level:2,tags:"#sport")
        newEvent(id++,title:"Olympic flame was lit for the first time", year:1928,level:2,tags:"#sport")
        newEvent(id++,title:"First Winter Olympics in America, Lake Placid", year:1932,level:1,tags:"#sport")
        newEvent(id++,title:"Winter Olympics held in Oslo", year:1952,tags:"#sport")
        newEvent(id++,title:"Black September terrorists killed 11 members of the Israeli Olympic team", year:1972,level:1,tags:"#sport")
        newEvent(id++,title:"Summer Olympics in Munich, Germany", year:1972,tags:"#sport")
        newEvent(id++,title:"Summer Olympics in Moscow", year:1980,level:2,tags:"#sport")
        newEvent(id++,title:"IOC drop the requirement that competitors at the Olympics must have amateur status", year:1986,level:2,tags:"#sport")
        newEvent(id++,title:"Winter Olympics in Lillehammer, Norway", year:1994,tags:"#sport")
        newEvent(id++,title:"Winter Olympics in Salt Lake City", year:2002,tags:"#sport")
        newEvent(id++,title:"Winter Olympics in Calgary, Canada", year:1988,tags:"#sport")
        
        
        //PERIODS,tags:"#period"
        /*
        newEvent(id++,title:"The Black Death plague ", from:1346, to:1353,text:"Killing 25 million people, one third of the European population. The plague is a highly contagious fever caused by the bacillus Yersinia pestis, which is carried by fleas that infest rats.",level:1,tags:"#period#miscellaneous")
        newEvent(id++,title:"Great Depression ", from:1929 , to:1939,level:1,tags:"#period#miscellaneous")
        newEvent(id++,title:"The Romanesque period", from:1000 , to:1199,tags:"#period#miscellaneous")
        newEvent(id++,title:"The Gothic period", from:1150 , to:1450,level:2,tags:"#period#miscellaneous#miscellaneous")
        newEvent(id++,title:"The Humanism cultural period", from:1500 , to:1599,level:2,tags:"#period#miscellaneous")
        newEvent(id++,title:"The European Renaissance", from:1300 , to:1699,level:1,tags:"#period#miscellaneous")
        newEvent(id++,title:"Age of Enlightenment", from:1688, to:1789,tags:"#period#miscellaneous")
        newEvent(id++,title:"The period of Romanticism", from:1770, to:1830,level:2,tags:"#period#miscellaneous")
        newEvent(id++,title:"The period of Realism", from:1830, to:1905,level:2,tags:"#period#miscellaneous")
        newEvent(id++,title:"Art Nouveau ", from:1880, to:1905,tags:"#period#miscellaneous")
        newEvent(id++,title:"Period of Modernism", from:1880, to:1965,tags:"#period#miscellaneous")
        newEvent(id++,title:"Start of the Baroque", year:1500,level:1,tags:"#period#miscellaneous")
        */
        
        
        //SCIENCE ,tags:"#science"
        
        newEvent(id++,title:"Isaac Newtown is born", year:1642, text: "",level:2,tags:"#science")
        newEvent(id++,title:"Galileo Galilei is born in Piza", year:1564, text: "",level:2,tags:"#science")
        newEvent(id++,title:"Nicolaus Copernicus is born in Polen", year:1473,text: "",tags:"#science")
        newEvent(id++,title:"René Descartes is born in France", year:1596, text: "",tags:"#science")
        newEvent(id++,title:"James Maxwell, electromagnetisms father is born", year:1831, text: "",tags:"#science")
        
        newEvent(id++,title:"Aristotle writes Meteorologica", year:-990,text: "The first book on weather.",tags:"#science")
        newEvent(id++,title:"Musa al-Kwarizmi born in Baghdad", year:780, text:"He introduced Hindu-Arabic numerals in his book Kitab al-jabr wa al-mugabalah.",tags:"#science")
        newEvent(id++,title:"Shen Kua of China writes about the magnetic compass", year:1086,level:2,tags:"#science")
        newEvent(id++,title:"First modern university", year:1088, text: "First modern university established in Bologna, Italy",tags:"#science")
        newEvent(id++,title:"Map of western China printed", year:1162, text:"Oldest known printed map",tags:"#science")
        newEvent(id++,title:"University of Oxford founded", year:1249,level:1,tags:"#science")
        newEvent(id++,title:"University of Cambridge founded", year:1284,level:2,tags:"#science")
        newEvent(id++,title:"Fire destroys four-fifths of London", year:1666,level:1, tags:"#science")
        newEvent(id++,title:"Leonardo da Vinci born", year:1452,level:1,tags:"#science")
        newEvent(id++,title:"Copernicus born in Poland", year:1473,level:1,tags:"#science")
        newEvent(id++,title:"Kepler publishes Mysterium cosmographicum", year:1596,level:2,tags:"#science")
        newEvent(id++,title:"Inquisition forces Galileo to recant his belief", year:1633, text:"Inquisition forces Galileo to recant his belief in Copernican theory.",level:2,tags:"#science")
        newEvent(id++,title:"Mathematical Principles of Natural Philosophy published", year:1000, text:"Isaac Newton describes the theory of gravity. The era of modern physics is inaugurated by the publication of his Mathematical Principles of Natural Philosophy, commonly called the Principia’. It was published in Latin and did not appear in English until 1729.",level:1,tags:"#science")
        newEvent(id++,title:"Louis Bleriot flies across the English Channel", year:1909,level:1,tags:"#science")
        newEvent(id++,title:"World’s first nuclear reactor", year:1946, text:"Opened in the USSR",level:2,tags:"#science")
        newEvent(id++,title:"US sends 4 monkeys into the stratosphere", year:1951,tags:"#science")
        newEvent(id++,title:"USSR launches the Sputnik satellite", year:1957,level:1,tags:"#science")
        newEvent(id++,title:"NASA founded", year:1958,level:2,tags:"#science")
        newEvent(id++,title:"Sikorsky becomes first woman in space", year:1963,level:2,tags:"#science")
        newEvent(id++,title:"IBM launches their PC", year:1981,level:2,tags:"#science")
        newEvent(id++,title:"Shuttle Columbia launched", year:1981,level:1,tags:"#science")
        newEvent(id++,title:"The Space Shuttle Challenger disaster", year:1986,level:1,tags:"#science")
        newEvent(id++,title:"Soviet Union launches Mir space station", year:1986,level:2,tags:"#science")
        newEvent(id++,title:"Hubble space telescope launched", year:1990,level:2,tags:"#science")
        newEvent(id++,title:"Space Shuttle Columbia disintegrates over Texas", year:2003,tags:"#science")
        
        //DISCOVERIES ,tags:"#discovery"
        
        
        newEvent(id++,title:"Pythagoras describes his theorem", year:-532,text:"Pythagoras of Crotona describes the relations between sides of right-angled triangle, and tone vibrations.",level:2,tags:"#discovery#science")
        newEvent(id++,title:"Archimedes explains principles of a lever", year:-212, text:"Area of circle, principles of lever, the screw, and buoyancy.",tags:"#discovery#science")
        newEvent(id++,title:"Eratosthenes determines the size of Earth", year:-194,tags:"#discovery#science")
        newEvent(id++,title:"Iceland discovered", year:861,tags:"#discovery")
        newEvent(id++,title:"Vikings discover Greenland", year:900,tags:"#discovery")
        newEvent(id++,title:"Leif Ericson lands in North America", year:1000, text: "The viking Leif Ericson lands in North America, calling it Vinland",level:2,tags:"#discovery")
        newEvent(id++,title:"Marco Polo leaves Venice for China", year:1272,text:"Marco Polo leaves Venice for China, where he would live and prosper for 17 years, returning to Venice where he died in 1323",level:2,tags:"#discovery")
        newEvent(id++,title:"Columbus discovers the New World", year:1492,level:1,tags:"#discovery")
        newEvent(id++,title:"Vasco da Gama discover sea route to India", year:1497,level:1,tags:"#discovery")
        newEvent(id++,title:"Balboa encounter the Pacific ocean", year:1513,level:2,tags:"#discovery")
        newEvent(id++,title:"Copernicus suggests that the earth moves around the sun", year:1514,level:2,tags:"#discovery")
        newEvent(id++,title:"Coffee from Arabia appears in Europe", year:1515,level:2,tags:"#discovery")
        newEvent(id++,title:"Magellan starts his sail journey", year:1519,level:2,tags:"#discovery")
        newEvent(id++,title:"Potato brought to Europe from South America", year:1540,tags:"#discovery")
        newEvent(id++,title:"Galileo Galilei discovers Jupiter’s 4 largest moons", year:1610,tags:"#discovery")
        newEvent(id++,title:"Boyle develops Boyle’s Law", year:1662, text:"Boyle develops Boyle’s Law: the volume of a gas varies with its pressure",level:2,tags:"#discovery")
        newEvent(id++,title:"Isaac Newton experiments with gravity", year:1664,tags:"#discovery#science")
        newEvent(id++,title:"Franz Mesmer uses hypnotism", year:1778, text:"It’s from his name we get the word mesmerized",tags:"#discovery")
        newEvent(id++,title:"Hennig Brand discovers phosphorus", year:1000, text:"German alchemist Hennig Brand discovers phosphorus, the first new element found since ancient times",tags:"#discovery")
        newEvent(id++,title:"Halley discovers Halley’s comet", year:1682,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Anthony van Leeuwenhoek discovers bacteria", year:1684,text:"he significance of which was not understood until the 19th century",tags:"#discovery#science")
        newEvent(id++,title:"First coffee planted in Brazil", year:1718,tags:"#discovery#science")
        newEvent(id++,title:"James Cook discovers Australia", year:1770,level:1,tags:"#discovery")
        newEvent(id++,title:"Michael Faraday discovers benzene", year:1825,tags:"#discovery")
        newEvent(id++,title:"Michael Faraday discovers electromagnetic induction", year:1831,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Gold discovered in California", year:1848,level:1,tags:"#discovery")
        newEvent(id++,title:"Rontgen discovers x-rays", year:1894,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Darwin publishes Origin of Species", year:1859,level:1,tags:"#discovery#science")
        newEvent(id++,title:"JJ Thompson discovers the electron", year:1896,tags:"#discovery#science")
        newEvent(id++,title:"Planck describing quantum mechanics", year:1900,tags:"#discovery#science")
        newEvent(id++,title:"Roald Amundsen discovers the magnetic north pole", year:1905,level:2,tags:"#discovery")
        newEvent(id++,title:"First blood transfusion", year:1907,level:2,tags:"#discovery")
        newEvent(id++,title:"Leo Baekeland discovers plastic", year:1907,tags:"#discovery")
        newEvent(id++,title:"Einstein proposes quantum theory", year:1908,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Roald Amundsen reaches the South Pole", year:1910,level:1,tags:"#discovery")
        newEvent(id++,title:"Alexander Fleming discovers penicillin", year:1928,level:1,tags:"#discovery")
        newEvent(id++,title:"James Chadwick discovers the neutron", year:1932,tags:"#discovery")
        newEvent(id++,title:"First artificial element, technetium, created", year:1937,tags:"#discovery")
        newEvent(id++,title:"Man reach summit of Mount Everes", year:1953,level:1,tags:"#discovery")
        newEvent(id++,title:"Dr Watson discovers the structure of DNA.", year:1953,tags:"#discovery#science")
        newEvent(id++,title:"Yuri Gagarin the first man in space", year:1961,level:1,tags:"#discovery#science")
        newEvent(id++,title:"Neil Armstrong is the first man on the moon", year:1969,level:1,tags:"#discovery#science")
        newEvent(id++,title:"Viking I lands on Mars", year:1976,level:2,tags:"#discovery#science")
        newEvent(id++,title:"HIV virus identified", year:1983,level:2,tags:"#discovery#science")
        newEvent(id++,title:"Farman discovers the hole in the ozone", year:1985,tags:"#discovery")
        newEvent(id++,title:"Roslin Institute in Scotland clones a sheep", year:1997,level:2,tags:"#discovery#science")
        
        //INVENTIONS ,tags:"#invention"
        
        
        newEvent(id++,title:"Roman calendar introduced", year:-535, text: "It had 10 months, with 304 days in a year that began in March.",level:2,tags:"#invention")
        newEvent(id++,title:"First seismoscope developed in China", year:132,level:1,tags:"#invention")
        newEvent(id++,title:"First printed newspaper appears in Peking", year:748,tags:"#invention")
        newEvent(id++,title:"First record of an automatic instrument", year:890, text:"First record of an automatic instrument, an organ-building treatise called Banu Musa.",tags:"#invention")
        newEvent(id++,title:"Toilet paper thought be used first in China", year:850,tags:"#invention")
        newEvent(id++,title:"Chinese money printed in 3 colors to stop counterfeit", year:1107,tags:"#invention")
        newEvent(id++,title:"Magnetic compass invented", year:1182,text:"The type of ore that attracted iron was known as magnesian stone because it was discovered in Magnesia in Asia Minor. The discovery of the magnet’s use in determining direction was made independently in China and Europe, the latter by English theologian and natural philosopher Alexander Neckam.",level:1,tags:"#invention")
        newEvent(id++,title:"Earliest recorded mention of playing cards, found in China.", year:969,level:2,tags:"#invention")
        newEvent(id++,title:"Musical notation systematised.", year:990,tags:"#invention")
        newEvent(id++,title:"Paper money printed in China.", year:1023,tags:"#invention")
        newEvent(id++,title:"Buttons invented to decorate clothing", year:1200,tags:"#invention")
        newEvent(id++,title:"Gun invented in China", year:1250,tags:"#invention")
        newEvent(id++,title:"The flioria gold coins created in Florence", year:1252,text:"It would become the first international currency",level:2,tags:"#invention")
        newEvent(id++,title:"The first mention of reading glasses", year:1286,level:2,tags:"#invention")
        newEvent(id++,title:"Drinking chocolate made by Aztecs", year:1350,level:2,tags:"#invention")
        newEvent(id++,title:"Johannes Gutenberg prints the Bible", year:1450,tags:"#invention")
        newEvent(id++,title:"First toothbrush made from hog bristles", year:1498,tags:"#invention")
        newEvent(id++,title:"Coiled springs invented", year:1502,level:1,tags:"#invention")
        newEvent(id++,title:"First handkerchief used in Europe", year:1503,tags:"#invention")
        newEvent(id++,title:"The pencil invented in England", year:1565,level:1,tags:"#invention")
        newEvent(id++,title:"Bottled beer invented in London.", year:1568,level:2,tags:"#invention")
        newEvent(id++,title:"The first mechanical calculator", year:1623, text:"German inventor Wilhelm Schickard invents the first mechanical calculator. Records detailing the machine’s workings were lost during the Thirty Years’ War.",level:2,tags:"#invention")
        newEvent(id++,title:"The barometer is invented", year:1644, text:"Italian Evangelista Torricelli invents the barometer",level:1,tags:"#invention")
        newEvent(id++,title:"A Paris cafe begins serving ice cream", year:1670,tags:"#invention")
        newEvent(id++,title:"Gabriel Daniel Fahrenheit invents the thermometer", year:1686,level:2,tags:"#invention")
        newEvent(id++,title:"Invention of steam pump", year:1698,level:1,tags:"#invention")
        newEvent(id++,title:"Jethro Tull invents the seed drill", year:1701,tags:"#invention")
        newEvent(id++,title:"Bartolomeo Cristofori invents the piano", year:1709,tags:"#invention")
        newEvent(id++,title:"Ketterer invents the cuckoo clock", year:1718,tags:"#invention")
        newEvent(id++,title:"The first eraser put on the end of a pencil", year:1752,tags:"#invention")
        newEvent(id++,title:"First street lights in New York", year:1761,level:2,tags:"#invention")
        newEvent(id++,title:"James Hargreaves invents the Spinning Jenny", year:1764,level:2,tags:"#invention")
        newEvent(id++,title:"James Watt invents rotary steam engine", year:1765,level:1,tags:"#invention")
        newEvent(id++,title:"Nicolas Cugnot builds the motorized carriage", year:1769,level:1,tags:"#invention")
        newEvent(id++,title:"Georges Louis Lesage patents the electric telegraph", year:1774,level:1,tags:"#invention")
        newEvent(id++,title:"Alexander Cummings invents the flush toilet", year:1775,level:2,tags:"#invention")
        newEvent(id++,title:"William Murdoch invents gas lighting", year:1792,tags:"#invention")
        newEvent(id++,title:"The first ambulance used in France", year:1792,tags:"#invention")
        newEvent(id++,title:"The first soft drink invented", year:1798,tags:"#invention")
        newEvent(id++,title:"Alessandro Volta invents the battery", year:1799,level:2,tags:"#invention")
        newEvent(id++,title:"Richard Trevithick builds the steam locomotive.", year:1804,level:2,tags:"#invention")
        newEvent(id++,title:"William Sturgeon invents the electromagnet", year:1825,level:2,tags:"#invention")
        newEvent(id++,title:"Samuel Mory patents the internal combustion engine", year:1826,level:1,tags:"#invention")
        newEvent(id++,title:"John Walker invents the modern matches", year:1827,level:1,tags:"#invention")
        newEvent(id++,title:"Louis Braille invents the stereoscope", year:1832,level:2,tags:"#invention")
        newEvent(id++,title:"Franklin Beale invents the coin press", year:1836,level:2,tags:"#invention")
        newEvent(id++,title:"John Deere patents a steel plow", year:1837,level:2,tags:"#invention")
        newEvent(id++,title:"Samuel Morse introduces the Morse code", year:1837,level:1,tags:"#invention")
        newEvent(id++,title:"Patent of the rubber band", year:1845,tags:"#invention")
        newEvent(id++,title:"Baking powder invented", year:1849,tags:"#invention")
        newEvent(id++,title:"Beer first sold in glass bottles", year:1850,tags:"#invention")
        newEvent(id++,title:"John Gorrie invents a refrigerating machine", year:1851,level:2,tags:"#invention")
        newEvent(id++,title:"Levi Strauss begins making trousers", year:1853,tags:"#invention")
        newEvent(id++,title:"Richard J Gatling invents the machine gun", year:1861,tags:"#invention")
        newEvent(id++,title:"Alessandro Volta demonstrated the electric pile or battery", year:1862,tags:"#invention")
        newEvent(id++,title:"First Atlantic cable laid", year:1866,level:1,tags:"#invention")
        newEvent(id++,title:"World’s first traffic light", year:1868,level:2,tags:"#invention")
        newEvent(id++,title:"Suez Canal opens", year:1869,level:1,tags:"#invention")
        newEvent(id++,title:"The first New York City subway line opens", year:1870,tags:"#invention")
        newEvent(id++,title:"Joseph Glidden invents barbed wire fencing", year:1874,tags:"#invention")
        newEvent(id++,title:"Electric dental drill patented by George Green", year:1875,tags:"#invention")
        newEvent(id++,title:"Graham Bell patents the telephone", year:1876,level:1,tags:"#invention")
        newEvent(id++,title:"Thomas Edison invents the phonograph", year:1877,level:2,tags:"#invention")
        newEvent(id++,title:"Otto Lilienthal builds a working glider", year:1877,tags:"#invention")
        newEvent(id++,title:"William Crookes invents cathode ray tube.", year:1879,tags:"#invention")
        newEvent(id++,title:"World’s first skyscraper", year:1885, text:"10-storey Home Insurance office, built in Chicago",level:2,tags:"#invention")
        newEvent(id++,title:"Karl Benz build gasoline-powered car", year:1885,level:2,tags:"#invention")
        newEvent(id++,title:"First set of contact lenses", year:1887,tags:"#invention")
        newEvent(id++,title:"Herz produces the first man-made radio waves", year:1887,tags:"#invention")
        newEvent(id++,title:"John Loud invents ballpoint pen", year:1888,tags:"#invention")
        newEvent(id++,title:"Patent of the roll film camera, the Kodak", year:1888,tags:"#invention")
        newEvent(id++,title:"Rudolph Diesel invents diesel engine", year:1892,tags:"#invention")
        newEvent(id++,title:"Orville Wright makes powered flight", year:1903,level:1,tags:"#invention")
        newEvent(id++,title:"Teabags invented by Thomas Suillivan", year:1904,tags:"#invention")
        newEvent(id++,title:"William Kellogg invents cornflakes", year:1906,tags:"#invention")
        newEvent(id++,title:"First Ford Model T rolls out", year:1908,level:1,tags:"#invention")
        newEvent(id++,title:"First commercially made color film", year:1909,tags:"#invention")
        newEvent(id++,title:"Artificial silk stockings made in Germany", year:1910,tags:"#invention")
        newEvent(id++,title:"First crossword puzzle published in New York Journal", year:1912,tags:"#invention")
        newEvent(id++,title:"Panama canal opens", year:1914,level:2,tags:"#invention")
        newEvent(id++,title:"Poison gas is used as a weapon", year:1915, text:"Poison gas is used as a weapon in Ypres, Belgium by German forces.",level:2,tags:"#invention")
        newEvent(id++,title:"Wireless telephone is invented", year:1919,tags:"#invention")
        newEvent(id++,title:"Tommy-gun is patented by John T Thompson", year:1920,tags:"#invention")
        newEvent(id++,title:"Jacob Schick patents the electric shaver", year:1923,tags:"#invention")
        newEvent(id++,title:"First Bubble Gum goes on sale in the US", year:1928,tags:"#invention")
        newEvent(id++,title:"Volkswagen Beetle is launched", year:1936,tags:"#invention")
        newEvent(id++,title:"Heinrich Focke creates the first successful helicopter", year:1936,level:2,tags:"#invention")
        newEvent(id++,title:"Supermarket trolleys introduced in Oklahoma", year:1938,tags:"#invention")
        newEvent(id++,title:"Maiden flight of pressurized airliner", year:1938, text:"Boeing Stratoliner",level:2,tags:"#invention")
        newEvent(id++,title:"Nylon stocking introduced", year:1940,tags:"#invention")
        newEvent(id++,title:"First solid-body electric guitar is built by Les Paul", year:1947,tags:"#invention")
        newEvent(id++,title:"Kalashnikov invents the AK-47", year:1947,tags:"#invention")
        newEvent(id++,title:"Velcro is patented", year:1951,level:2,tags:"#invention")
        newEvent(id++,title:"Chrysler introduces power steering", year:1951,tags:"#invention")
        newEvent(id++,title:"Sony invents pocket-sized transistor radio", year:1952,level:2,tags:"#invention")
        newEvent(id++,title:"Danish toymakers launches Lego", year:1958,level:1,tags:"#invention")
        newEvent(id++,title:"Skateboard invented", year:1958,tags:"#invention")
        newEvent(id++,title:"Dow Corp invent silicone breast implants", year:1962,tags:"#invention")
        newEvent(id++,title:"Bill Gates and Paul Allen use their first computer", year:1968,tags:"#invention")
        newEvent(id++,title:"Seiko launches the quartz wristwatch", year:1967,tags:"#invention")
        newEvent(id++,title:"IBM introduces the floppy disk ", year:1970,tags:"#invention")
        newEvent(id++,title:"Texas Instruments launches the pocket calculator", year:1972,level:1,tags:"#invention")
        newEvent(id++,title:"Nike running shoes launched", year:1972,level:1,tags:"#invention")
        newEvent(id++,title:"Gillette introduces the disposable razor", year:1974,level:1,tags:"#invention")
        newEvent(id++,title:"GM introduces the catalytic converter", year:1974,tags:"#invention")
        newEvent(id++,title:"IBM launches the laser printer", year:1975,tags:"#invention")
        newEvent(id++,title:"Apple II the first mass-produced home computer", year:1977,tags:"#invention")
        newEvent(id++,title:"First arcade video game, Space Invaders", year:1978,tags:"#invention")
        newEvent(id++,title:"Philips invents the CD", year:1980,level:1,tags:"#invention")
        newEvent(id++,title:"First commercial cell phone call", year:1983,level:2,tags:"#invention")
        newEvent(id++,title:"Sinclair introduces the battery-operated car", year:1985,tags:"#invention")
        newEvent(id++,title:"US introduces the F-117 stealth fighter", year:1988,tags:"#invention")
        newEvent(id++,title:"Tim Berners-Lee develops the World Wide Web", year:1989,tags:"#invention")
        newEvent(id++,title:"Wikipedia started", year:2001,level:2,tags:"#invention")
        newEvent(id++,title:"Facebook founded", year:2004,tags:"#invention")
        newEvent(id++,title:"YouTube launched", year:2005,tags:"#invention")
        newEvent(id++,title:"Apple launches the iPhone", year:2007,level:1,tags:"#invention")
        newEvent(id++,title:"Apple launches the iPad", year:2010,tags:"#invention")
        
        //HEAD OF STATE
        
        newEvent(id++,title:"Abraham Lincolns Gettysburg Address (Speech)", year:1865,level:2,tags:"#headOfState")
        //_?newEvent(id++,title:"Babylon ruled by Nebuchadnezzar", from: -605, to: -562,level:2,tags:"#headOfState")
        newEvent(id++,title:"Rome founded by Romulus", year:-753,tags:"#headOfState")
        //_?newEvent(id++,title:"Alexander the Great rule Macedonia", from:-336 , to:-323,level:1,tags:"#headOfState")
        //_?newEvent(id++,title:"Rule of Cleopatra in Egypt", from:-51, to: -30,level:2,tags:"#headOfState")
        newEvent(id++,title:"Julius Caesar assassinated", year:-44,level:1,tags:"#headOfState")
        newEvent(id++,title:"Nero becomes last Caesar", year:54,level:2,tags:"#headOfState")
        newEvent(id++,title:"Tiberius becomes roman Emperor", year:14,tags:"#headOfState")
        newEvent(id++,title:"Marcus Aurelius becomes emperor of Rome", year:161,tags:"#headOfState")
        newEvent(id++,title:"Emperor Commodus assisinated in Rome", year:193,level:2,tags:"#headOfState")
        newEvent(id++,title:"Dagobert becomes King of the Franks", year:629,level:2,tags:"#headOfState")
        newEvent(id++,title:"Charlemagne becomes king of the Franks", year:771,level:1,tags:"#headOfState")
        newEvent(id++,title:"Charlemagne dies of pleurisy", year:814,tags:"#headOfState")
        newEvent(id++,title:"Mieczyslaw I becomes first ruler of Poland", year:960,tags:"#headOfState")
        newEvent(id++,title:"Henry V crowned Holy Roman Emperor", year:1111,level:2,tags:"#headOfState")
        newEvent(id++,title:"Honorius II is elected pope", year:1124,tags:"#headOfState")
        newEvent(id++,title:"Richard I becomes King of England", year:1189, text:"Known as Coeur de Lion or Richard the Lionheart",level:1,tags:"#headOfState")
        newEvent(id++,title:"Richard II made King of England", year:1377,tags:"#headOfState")
        newEvent(id++,title:"Henry VI becomes King of England ", year:1429, text:"He is younger than a year old.",tags:"#headOfState")
        newEvent(id++,title:"Ivan the Great first czar of Russia", year:1462,level:1,tags:"#headOfState")
        newEvent(id++,title:"Ivan the Terrible (Ivan IV) crowned Czar", year:1547,level:1,tags:"#headOfState")
        newEvent(id++,title:"Mary Tudor becomes Queen of England", year:1554,level:1,tags:"#headOfState")
        newEvent(id++,title:"Mary Queen of Scots executed", year:1587,level:2,tags:"#headOfState")
        newEvent(id++,title:"Peter the Great crowned Czar", year:1689,level:1,tags:"#headOfState")
        newEvent(id++,title:"St Petersburg founded by Peter the Great", year:1703,tags:"#headOfState")
        newEvent(id++,title:"George I becomes King of Britain", year:1714,level:2,tags:"#headOfState")
        newEvent(id++,title:"Louis XV becomes King of France", year:1715,tags:"#headOfState")
        newEvent(id++,title:"George III becomes King of Britain", year:1760,tags:"#headOfState")
        newEvent(id++,title:"Catherine the Great becomes Czarina", year:1762,level:2,tags:"#headOfState")
        newEvent(id++,title:"Elias Boudinot elected President of the US", year:1783,tags:"#headOfState")
        newEvent(id++,title:"Thomas Mifflin elected President of the US", year:1784,tags:"#headOfState")
        newEvent(id++,title:"Richard Henry Lee elected President of the US", year:1785,tags:"#headOfState")
        newEvent(id++,title:"Nathan Gorman elected President of the US", year:1786,tags:"#headOfState")
        newEvent(id++,title:"Arthur St. Clair elected as President of the US", year:1787,tags:"#headOfState")
        newEvent(id++,title:"Cyrus Griffin elected President of the US Congress", year:1788,tags:"#headOfState")
        newEvent(id++,title:"George Washington elected US President", year:1789,level:1,tags:"#headOfState")
        newEvent(id++,title:"Paul I becomes Tsar of Russia", year:1792,tags:"#headOfState")
        newEvent(id++,title:"Napoleon Bonaparte declares himself dictator of France", year:1799,level:2,tags:"#headOfState")
        newEvent(id++,title:"Napoleon crowns himself Emperor of France", year:1804,tags:"#headOfState")
        newEvent(id++,title:"Napoleon gives crown of Spain to Ferdinand", year:1813,level:2,tags:"#headOfState")
        newEvent(id++,title:"James Monroe elected US President", year:1816,tags:"#headOfState")
        newEvent(id++,title:"John Quincy Adams elected US President", year:1824,tags:"#headOfState")
        newEvent(id++,title:"George Canning elected Prime Minister of Britain", year:1827,tags:"#headOfState")
        newEvent(id++,title:"Wellington becomes Prime Minister of Britain", year:1828,level:2,tags:"#headOfState")
        newEvent(id++,title:"Andrew Jackson elected US President.", year:1828,tags:"#headOfState")
        newEvent(id++,title:"Martin van Buren elected US President", year:1836,tags:"#headOfState")
        newEvent(id++,title:"John Tyler becomes US President", year:1841,tags:"#headOfState")
        newEvent(id++,title:"Millard Fillmore becomes US President", year:1850,tags:"#headOfState")
        newEvent(id++,title:"James Buchanan elected US President", year:1856,tags:"#headOfState")
        newEvent(id++,title:"Bismarck becomes Prime Minister of Germany", year:1862,level:2,tags:"#headOfState")
        newEvent(id++,title:"Gladstone becomes Prime Minister in Britain", year:1868,tags:"#headOfState")
        newEvent(id++,title:"Ulysses S Grant elected US President", year:1868,level:1,tags:"#headOfState")
        newEvent(id++,title:"Oscar II becomes King of Sweden and Norway", year:1872,tags:"#headOfState")
        newEvent(id++,title:"Benjamin Disraeli elected Prime Minister of Britain", year:1874,tags:"#headOfState")
        newEvent(id++,title:"Rutherford Hayes elected US President", year:1876,tags:"#headOfState")
        newEvent(id++,title:"William Glastone elected British Prime Minister", year:1880,tags:"#headOfState")
        newEvent(id++,title:"James Garfield elected US President", year:1880,level:2,tags:"#headOfState")
        newEvent(id++,title:"US President Garfield killed", year:1881,text:"Chester Arthur becomes US President",level:2,tags:"#headOfState")
        newEvent(id++,title:"Steven Grover Cleveland elected US President.", year:1884,tags:"#headOfState")
        newEvent(id++,title:"William Henry Harrison elected US President", year:1888,tags:"#headOfState")
        newEvent(id++,title:"Gladstone elected British Prime Minister", year:1892,tags:"#headOfState")
        newEvent(id++,title:"Nicholas II becomes Tsar of Russia", year:1894,tags:"#headOfState")
        newEvent(id++,title:"William McKinley elected US President", year:1896,tags:"#headOfState")
        //_?newEvent(id++,title:"Woodrow Wilson is US president", from:1913, to:1921,level:2,tags:"#headOfState")
        newEvent(id++,title:"Woodrow Wilson is elected US president", year:1933,level:1,tags:"#headOfState")
        
        newEvent(id++,title:"Adolf Hitler becomes leader of Germany", year:1933,level:1,tags:"#headOfState")
        newEvent(id++,title:"Queen Elizabeth II crowned", year:1953,level:1,tags:"#headOfState")
        newEvent(id++,title:"Fidel Castro takes power in Cuba", year:1959,level:2,tags:"#headOfState")
        newEvent(id++,title:"President John F Kennedy assassinated.", year:1963,level:1,tags:"#headOfState")
        newEvent(id++,title:"Yasser Arafat becomes leader of PLO", year:1969,level:2,tags:"#headOfState")
        newEvent(id++,title:"Vladimir Putin elected President of Russia", year:2000,level:1,tags:"#headOfState")
        newEvent(id++,title:"George W Bush defeats Al Gore to become US President", year:2000,level:1,tags:"#headOfState")
        newEvent(id++,title:"Dmitri Medvedev elected President of Russia", year:2008,level:2,tags:"#headOfState")
        newEvent(id++,title:"Obama becomes first black US President", year:2009,level:1,tags:"#headOfState")
        newEvent(id++,title:"Pope John Paul II dies", year:2005,level:2,tags:"#headOfState")
        
        
        newEvent(id++,title:"Abraham Lincoln is elected US president", year:1861,level:2,tags:"#headOfState")
        newEvent(id++,title:"Richard Nixon is elected US president", year:1969,level:2,tags:"#headOfState")

        
        newEvent(id++,title:"Thomas Jefferson is elected US president", year:1801,level:2,tags:"#headOfState")
        newEvent(id++,title:"Herbert Hoover is elected US president", year:1929,level:3,tags:"#headOfState")
        newEvent(id++,title:"Franklin D. Roosevelt is elected US president", year:1933,level:2,tags:"#headOfState")
        newEvent(id++,title:"Harry Truman is elected US president", year:1945,level:3,tags:"#headOfState")
        newEvent(id++,title:"Dwight Eisenhower is elected US president", year:1953,level:3,tags:"#headOfState")
        newEvent(id++,title:"John F. Kennedy is elected US president", year:1961,level:1,tags:"#headOfState")
        newEvent(id++,title:"Jimmy Carter is elected US president", year:1977,level:2,tags:"#headOfState")
        newEvent(id++,title:"Ronald Reagan is elected US president", year:1981,level:2,tags:"#headOfState")
        newEvent(id++,title:"Bill Clinton is elected US president", year:1993,level:2,tags:"#headOfState")
        
        newEvent(id++,title:"Vladimir Lenin is elected leader of USSR", year:1922,level:2,tags:"#headOfState")
        newEvent(id++,title:"Joseph Stalinis elected leader of USSR", year:1924,level:2,tags:"#headOfState")
        newEvent(id++,title:"Nikita Khrushchev is elected leader of USSR", year:1955,level:3,tags:"#headOfState")
        newEvent(id++,title:"Leonid Brezhnev is elected leader of USSR", year:1964,level:3,tags:"#headOfState")
        newEvent(id++,title:"Boris Yeltsin is elected 1st President of Russia", year:1991,level:2,tags:"#headOfState")
        /*
        
        
        newEvent(id++,title:"Thomas Jefferson is US president", from:1801, to:1809,level:2,tags:"#headOfState")
        newEvent(id++,title:"Herbert Hoover is US president", from:1929, to:1933,tags:"#headOfState")
        
        newEvent(id++,title:"Franklin D. Roosevelt is US president", from:1933, to:1945,level:1,tags:"#headOfState")
        newEvent(id++,title:"Harry Truman is US president", from:1945, to:1953,level:2,tags:"#headOfState")
        newEvent(id++,title:"Dwight Eisenhower is US president", from:1953, to:1961,level:2,tags:"#headOfState")
        newEvent(id++,title:"John F. Kennedy is US president", from:1961, to:1963,level:1,tags:"#headOfState")
        newEvent(id++,title:"Jimmy Carter is US president", from:1977, to:1981,tags:"#headOfState")
        newEvent(id++,title:"Ronald Reagan is US president", from:1981, to:1989,tags:"#headOfState")
        newEvent(id++,title:"Bill Clinton is US president", from:1993, to:2001,level:1,tags:"#headOfState")
        */
        /*
        newEvent(id++,title:"Vladimir Lenin is leader of USSR", from:1922, to:1924,level:1,tags:"#headOfState")
        newEvent(id++,title:"Joseph Stalin is leader of USSR", from:1924, to:1953,level:1,tags:"#headOfState")
        newEvent(id++,title:"Nikita Khrushchev is leader of USSR", from:1955, to:1964,level:2,tags:"#headOfState")
        newEvent(id++,title:"Leonid Brezhnev is leader of USSR", from:1964, to:1982,level:2,tags:"#headOfState")
        newEvent(id++,title:"Boris Yeltsin is 1st President of Russia", from:1991, to:1999,tags:"#headOfState")
        */
        newEvent(id++,title:"Nicolae Ceaușescu shot by a firing squad", year:1989,tags:"#headOfState")
        
        //WARS
        
        
        newEvent(id++,title:"King David conquers Jerusalem", year:-990,level:2,tags:"#war")
        newEvent(id++,title:"The Romans invade Britain", year:-55,level:2,tags:"#war")
        newEvent(id++,title:"Angles and Saxons conquer Britain", year:449,level:2,tags:"#war")
        newEvent(id++,title:"Attila the Hun crosses the Rhine into Gaul", year:451,tags:"#war")
        newEvent(id++,title:"Vandals conquer Rome", year:455,level:2,tags:"#war")
        newEvent(id++,title:"Battle of Vouille", year:507, text:"Clovis, King of the Franks, defeats the Visigoths at the Battle of Vouille",tags:"#war")
        newEvent(id++,title:"The Lombards invade Italy", year:568,tags:"#war")
        newEvent(id++,title:"Arabs destroy the city of Carthage", year:695, text:"Ending Byzantine rule in North Africa",tags:"#war")
        newEvent(id++,title:"Moslem conquest of Spain", year:711,tags:"#war")
        newEvent(id++,title:"Battle of Tours", year:732, text:"Frankish forces led by Charles Martel halt the Muslim advance into Europe",tags:"#war")
        newEvent(id++,title:"Charlemagne declares war against the Saxons in Germany", year:748,tags:"#war")
        newEvent(id++,title:"Battle of Atlakh", year:751, text: "Islamic army defeats the Chinese at the Battle of Atlakh, giving Muslims control of the Silk Road.",tags:"#war")
        newEvent(id++,title:"William the Conqueror invades England", year:1066,text:"William the Conqueror, from Normandy in France, invades England, defeats last Saxon king, Harold II, at Battle of Hastings",tags:"#war")
        newEvent(id++,title:"Pope Urban II calls for holy war", year:1094,text:"At Council of Clermont, Pope Urban II calls for holy war to wrest Jerusalem from Muslims, launching the First Crusade the next year. Gilbert Crispin’s “A Friendly Disputation” published – a series of discussions on the opposing arguments of faiths between him and a Jew from Mainz.",level:2,tags:"#war")
        newEvent(id++,title:"Crusaders capture Jerusalem", year:1099,tags:"#war")
        newEvent(id++,title:"Vikings invade Ireland", year:795,tags:"#war")
        newEvent(id++,title:"Second Crusade led by King Louis VIII", year:1145,tags:"#war")
        newEvent(id++,title:"Genghis Khan captures Peking", year:1241,tags:"#war")
        newEvent(id++,title:"Robert the Bruce´s victory over the English", year:1314, text:"Robert the Bruce leads the Scots to victory over the English at the Battle of Bannockburn",tags:"#war")
        //_?newEvent(id++,title:"The Hundred Years War", from:1337, to:1453,text:"The Hundred Years War begins between kings of England and France for control of France.",level:1,tags:"#war")
        newEvent(id++,title:"Start of The Hundred Years War", year:1337,level:2,tags:"#war")
        newEvent(id++,title:"End of The Hundred Years War", year:1453,level:2,tags:"#war")
        
        newEvent(id++,title:"Joan of Arc leads French against English", year:1428,level:2,tags:"#war")
        //_?newEvent(id++,title:"Wars of the Roses", from:1455, to:1487,level:1,tags:"#war")
        newEvent(id++,title:"Start of Wars of the Roses", year:1455,level:2,tags:"#war")
        //_?newEvent(id++,title:"The Thirty Years’ War", from:1618, to:1648, text:"War between Protestants and Catholics begins.",level:1,tags:"#war")
        newEvent(id++,title:"Start of The Thirty Years’ War", year:1618,level:2,tags:"#war")
        newEvent(id++,title:"End of The Thirty Years’ War", year:1648,level:2,tags:"#war")
        
        newEvent(id++,title:"Cromwell invades Ireland", year:1649,tags:"#war")
        newEvent(id++,title:"Cromwell becomes ruler of England, Scotland and Ireland", year:1653,tags:"#war")
        newEvent(id++,title:"Battle of Trafalga", year:1805,level:1,tags:"#war")
        newEvent(id++,title:"Wellington invades France", year:1813,tags:"#war")
        newEvent(id++,title:"Battle of Waterloo", year:1815,level:2,tags:"#war")
        //_?newEvent(id++,title:"The American Civil War", from:1861, to:1865,level:1,tags:"#war")
        newEvent(id++,title:"Start of The American Civil War", year:1861,level:1,tags:"#war")
        newEvent(id++,title:"End of The American Civil War", year:1865,level:2,tags:"#war")
        //_?newEvent(id++,title:"Franco-Prussian war", from:1870, to:1871,level:2,tags:"#war")
        newEvent(id++,title:"Start of Franco-Prussian war", year:1870,level:1,tags:"#war")
        newEvent(id++,title:"Battle of Little Big Horn", year:1876,tags:"#war")
        //_?newEvent(id++,title:"Second Boer War", from:1899, to:1902,tags:"#war")
        //_?newEvent(id++,title:"World War I", from:1914, to:1918,level:1,tags:"#war")
        newEvent(id++,title:"Start of World War I", year:1914,level:1,tags:"#war")
        newEvent(id++,title:"End of World War I", year:1918,level:1,tags:"#war")
        //_?newEvent(id++,title:"World War II", from:1939, to:1945,level:1,tags:"#war")
        newEvent(id++,title:"Start of World War II", year:1939,level:1,tags:"#war")
        newEvent(id++,title:"End of World War II", year:1945,level:1,tags:"#war")
        
        newEvent(id++,title:"Japan’s attack on Pearl Harbor", year:1941,level:1,tags:"#war")
        newEvent(id++,title:"Allied D-Day landings at Normandy", year:1944,level:1,tags:"#war")
        newEvent(id++,title:"Gulf War erupts as NATO defends Kuwait", year:1990,level:1,tags:"#war")
        //_?newEvent(id++,title:"The Bosnian War", from:1992, to:1995,tags:"#war")
        newEvent(id++,title:"Start of The Bosnian War", year:1992,tags:"#war")
        //_?newEvent(id++,title:"Soviet–Afghan War", from:1979, to:1989,tags:"#war")
        newEvent(id++,title:"End of the Soviet–Afghan War", year:1989,tags:"#war")
        //_?newEvent(id++,title:"The Korean War", from:1950, to:1953,level:2,tags:"#war")
        newEvent(id++,title:"Start of The Korean War", year:1950,level:2,tags:"#war")
        newEvent(id++,title:"End of The Korean War", year:1953,tags:"#war")
        //_?newEvent(id++,title:"Vietnam War", from:1954,to:1975,level:1,tags:"#war")
        newEvent(id++,title:"Start of The Vietnam War", year:1954,level:1,tags:"#war")
        newEvent(id++,title:"End of The Vietnam War", year:1975,level:1,tags:"#war")
        newEvent(id++,title:"Russia invades Afghanistan", year:1979,level:2,tags:"#war")
        
        newEvent(id++,title:"Bay of Pigs Invasion", year:1961,level:1,tags:"#war")
        //_?newEvent(id++,title:"Iran Iraq War",from:1980 , to:1988 ,tags:"#war")
        newEvent(id++,title:"Falklands War", year:1982,level:2,tags:"#war")
        //_?newEvent(id++,title:"Gulf War", from:1990 , to:1991,tags:"#war")
        newEvent(id++,title:"Start of The first Gulf War", year:1990,level:2,tags:"#war")
        //_?newEvent(id++,title:"Croatian War of Independence", from:1991, to: 1995,tags:"#war")
        //_?newEvent(id++,title:"Bosnian War", from:1992 , to:1995,level:2,tags:"#war")
        //_?newEvent(id++,title:"Kosovo War", from:1998 , to:1999,level:2,tags:"#war")
        
        /*
        newEvent(id++,title:"Crimean War", from:1853 , to:1856,level:2,tags:"#war")
        newEvent(id++,title:"Chinese Civil War", from:1927 , to:1949,tags:"#war")
        newEvent(id++,title:"Spanish Civil War", from:1936 , to:1939,tags:"#war")
        
        newEvent(id++,title:"Boxer Rebellion",from:1899 , to:1901,level:2,tags:"#war")
        newEvent(id++,title:"Russian Revolution", year:1905,level:1,tags:"#war")
        newEvent(id++,title:"Russian Civil War",from:1917 , to:1923 ,level:2,tags:"#war")
        newEvent(id++,title:"Mexican Revolution", from:1910 , to:1921,tags:"#war")
        newEvent(id++,title:"French Revolution", from:1789, to:1799,level:1,tags:"#war")
        */
        
        newEvent(id++,title:"Start of The Crimean War", year:1853,tags:"#war")
        newEvent(id++,title:"Start of The Chinese Civil War", year:1927,tags:"#war")
        newEvent(id++,title:"Start of The Russian Revolution", year:1905,tags:"#war")
        newEvent(id++,title:"Start of The French Revolution", year:1789,tags:"#war")
        newEvent(id++,title:"Start of The Napoleonic Wars", year:1803,tags:"#war")
        newEvent(id++,title:"End of The Napoleonic Wars", year:1815,tags:"#war")
        //_?newEvent(id++,title:"Napoleonic Wars", from:1803, to: 1815)
        newEvent(id++,title:"Year of the Soccer War or 100 Hour War", year:1969, level:2,tags:"#war")
        
        //NOT USED
        /*
        
        newEvent(id++,title:"Russo-Persian War", from:1804 , to:1813)
        newEvent(id++,title:"Rum Rebellion", from:1808 , to:1810)
        newEvent(id++,title:"Spanish American wars of independence", from:1808, to: 1833)
        newEvent(id++,title:"Mexican War of Independence",from:1810 , to:1821 )
        newEvent(id++,title:"War of 1812",from:1812 , to:1815 )
        newEvent(id++,title:"Creek War", from:1813, to: 1814)
        newEvent(id++,title:"Seminole Wars", from:1817 , to:1858)
        newEvent(id++,title:"Zulu Wars of Conquest", from:1818, to: 1828)
        newEvent(id++,title:"Texasâ€“Indian wars", from:1820, to: 1875)
        newEvent(id++,title:"Greek War of Independence",from:1821, to: 1832 )
        newEvent(id++,title:"Comancheâ€“Mexico War",from:1821 , to:1848 )
        newEvent(id++,title:"Java War", from:1825 , to:1830)
        newEvent(id++,title:"Winnebago War", from:1827 , to:1827)
        newEvent(id++,title:"Black Hawk War", from:1832 , to:1832)
        newEvent(id++,title:"Texas Revolution", from:1835 , to:1836)
        newEvent(id++,title:"First Opium War", from:1839 , to:1842)
        newEvent(id++,title:"Navajo Wars",from:1846 , to:1864 )
        newEvent(id++,title:"Mexican-American War", from:1846, to: 1848)
        newEvent(id++,title:"Apache Wars", from:1849 , to:1924)
        newEvent(id++,title:"California Indian Wars",from:1850, to: 1865 )
        newEvent(id++,title:"Crimean War", from:1853 , to:1856)
        newEvent(id++,title:"American Civil War",from: 1861, to: 1865)
        newEvent(id++,title:"Snake War", from:1864 , to:1868)
        newEvent(id++,title:"Red Cloud's War",from:1866 , to:1868 )
        newEvent(id++,title:"Comanche Campaign",from:1867 , to:1875 )
        newEvent(id++,title:"Great Sioux War (Black Hills War)",from:1876, to: 1877 )
        newEvent(id++,title:"Nez Perce War", from:1877 , to:1877)
        newEvent(id++,title:"Cheyenne War",from:1878, to: 1879 )
        newEvent(id++,title:"Sheepeater Indian War",from:1879, to: 1879 )
        newEvent(id++,title:"Victorio's War",from:1879 , to:1880  )
        
        newEvent(id++,title:"Second Boer War", from:1899 , to:1902)
        
        
        newEvent(id++,title:"World War I", from:1914 , to:1918)
        newEvent(id++,title:"Turkish War of Independence",from:1919 , to:1923 )
        newEvent(id++,title:"Irish War of Independence", from:1919 , to:1921)
        
        newEvent(id++,title:"World War II", from:1939 , to:1945)
        newEvent(id++,title:"Greek Civil War", from:1946 , to:1949)
        newEvent(id++,title:"Arabâ€“Israeli War", from:1948 , to:1949)
        newEvent(id++,title:"Korean War", from:1950 , to:1953)
        newEvent(id++,title:"Mau Mau Uprising", from:1952 , to:1960)
        newEvent(id++,title:"Cuban Revolution",from:1953 , to:1959 )
        newEvent(id++,title:"Algerian War",from:1954 , to:1962 )
        newEvent(id++,title:"Vietnam War", from:1955, to: 1975)
        
        */
        
        
        //TEST
        /*
        newEvent(id++,title:"war (1918-1939)", from: 1918, to:1939,level: 1)
        newEvent(id++,title:"Test between (1918-1960)", from: 1918, to:1960,text:"First record of an automatic instrument, an organ-building treatise called Banu Musa. First record of an automatic instrument, an organ-building treatise called Banu Musa.",level: 2)
        newEvent(id++,title:"Someone is born (1751)", year: 1751,level:2)
        newEvent(id++,title:"old war (1918-1939)", from: -540, to:-300, text:"The best approach to add padding to a UILabel is to subclass UILabel and add an edgeInsets property. You then set the desired insets and the label will be drawn accordingly.",level: 3)
        */
        
        
        /*
        newEvent(id++,title:"World population reaches the 6 billion mark", year:1999)
        newEvent(id++,title:"Dmitri Medvedev elected President of Russia", year:2008)
        newEvent(id++,title:"Confucius born in China", year:-551)
        */
        //newEvent(id++,title: "Triassic period", from:Int32(-248 * aMillion), to: Int32(-205 * aMillion),level:2)
        
        //newEvent(id++,title: "In the old days", from:-990, to: -800,level:2)
        //newEvent(id++,title: "In the old days SPLIT", from:-990, to: 500,level:2)
        
        //pass newEvent(id++,title: "old days -700 -300", from:-700, to: -300,level:2)
        //newEvent(id++,title: "old days -600 -540", from:-950, to: -540,level:2)
        //newEvent(id++,title: "old days 900 1000", from:900, to: 1000,level:2)
        //newEvent(id++,title: "new days 900 997", from:900, to: 997,level:2)
        //newEvent(id++,title: "new days 1523 1540", from:1513, to: 1540,level:2)
        //newEvent(id++,title: "King David conquers Jerusalem", year:-990,level:2,tags:"#war")
        //newEvent(id++,title:"First Olympiad in Greece", year:-776,level:2,tags:"#war#curiosa")
        
        print("populated new data")
        
        
        
        save()
        
        dataPopulatedValue = 1
        saveGameData()
        
        
        
        NSUserDefaults.standardUserDefaults().setInteger(GlobalConstants.numberOfHintsAtStart, forKey: "hintsLeftOnAccount")
        
        completePopulating?()
    }
    
    func newEvent(idForUpdate:Int,title:String, from: Int32, to:Int32, text:String = "", level:Int = 3, tags:String = "")
    {
        HistoricEvent.createInManagedObjectContext(self.managedObjectContext!,idForUpdate:idForUpdate,  title:title, from: from, to:to, text:text, level:level,tags:tags)
    }
    
    func newEvent(idForUpdate:Int,title:String, year: Int32, text:String = "", level:Int = 3, tags:String = "")
    {
        HistoricEvent.createInManagedObjectContext(self.managedObjectContext!,idForUpdate:idForUpdate,  title:title, year:year, text:text,level:level, tags:tags)
    }
    
    func updateOkScore(historicEvent:HistoricEvent, deltaScore:Int)
    {
        //okScoreID = Int(okScoreID as! NSNumber) + deltaScore
        historicEvent.okScore = historicEvent.okScore + Int32(deltaScore)
        if historicEvent.okScore < 0
        {
            historicEvent.okScore = 0
        }
        save()
    }
    
    func updateGoodScore(historicEvent:HistoricEvent, deltaScore:Int)
    {
        //goodScoreID = Int(goodScoreID as! NSNumber) + deltaScore
        historicEvent.goodScore = historicEvent.goodScore + Int16(deltaScore)
        if historicEvent.goodScore < 0
        {
            historicEvent.goodScore = 0
        }
        save()
    }
    
    func updateLoveScore(historicEvent:HistoricEvent, deltaScore:Int)
    {
        //loveScoreID = Int(loveScoreID as! NSNumber) + deltaScore
        historicEvent.loveScore = historicEvent.loveScore + Int16(deltaScore)
        if historicEvent.loveScore < 0
        {
            historicEvent.loveScore = 0
        }
        save()
    }
    
    func updateGameData(deltaOkPoints:Int,deltaGoodPoints:Int,deltaLovePoints:Int)
    {
        okScoreValue = Int(okScoreValue as! NSNumber) + deltaOkPoints
        goodScoreValue = Int(goodScoreValue as! NSNumber) + deltaGoodPoints
        loveScoreValue = Int(loveScoreValue as! NSNumber) + deltaLovePoints
    }
    
    func addRecordToGameResults(value:String)
    {
        //self.gameResultsValue.insertObject(value, atIndex: 0)
        self.gameResultsValues.append(value)
    }

    
    func getRandomHistoricEventsWithPrecision(var precisionYears:Int, numEvents:Int) -> [HistoricEvent]
    {
        //this value is used to ensure events used less than others have a better chance of being used
        var getValuesFromIndexCount = UInt32(Double(historicEventItems.count) * 0.75)
        let failSafePercision:Int = 10
        var failSafeIndexCount:UInt32 = UInt32(historicEventItems.count)
        
        var historicEventsWithPrecision:[HistoricEvent] = []
        //var randomNum:Int = Int(arc4random_uniform(UInt32(getValuesFromIndexCount)))
        //var event = historicEventItems![randomNum] as HistoricEvent
        //historicEventsWithPrecision.append(event)

        var roundsBeforeFailSafe = 10
        var notAcceptableValues = false
        repeat{
            historicEventsWithPrecision = []
            for var i = 0 ; i < numEvents ; i++
            {
                //randomNum = Int(arc4random()) % historicEventItems.count
                let randomNum = Int(arc4random_uniform(UInt32(getValuesFromIndexCount)))
                let event = historicEventItems![randomNum] as HistoricEvent
                historicEventsWithPrecision.append(event)
                
            }
            notAcceptableValues = false
            
            for var i = 0 ; i < numEvents ; i++
            {
                var foundMySelfOnce = false
                let value = historicEventsWithPrecision[i].fromYear
                for item in historicEventsWithPrecision
                {
                    if item == historicEventsWithPrecision[i]
                    {
                        if foundMySelfOnce
                        {
                            notAcceptableValues = true
                            break
                        }
                        else
                        {
                            foundMySelfOnce = true
                            continue
                        }
                    }
                    if (item.fromYear - precisionYears) > value || item.fromYear + precisionYears < value
                    {
                        //println("test : value \(item.fromYear)")
                        continue

                    }
                    else
                    {
                        notAcceptableValues = true
                        break
                    }
        
                }
            }
            
            if roundsBeforeFailSafe <= 0
            {
                getValuesFromIndexCount = failSafeIndexCount
                precisionYears = failSafePercision
                failSafeIndexCount = failSafeIndexCount <= 5 ? failSafeIndexCount : failSafeIndexCount - 1
            }
            else
            {
                roundsBeforeFailSafe--
            }
        
        }while(notAcceptableValues)
        return historicEventsWithPrecision
    }
    
    func shuffleEvents()
    {
        historicEventItems = shuffle(historicEventItems)
    }
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let ecount = list.count
        for i in 0..<(ecount - 1) {
            let j = Int(arc4random_uniform(UInt32(ecount - i))) + i
            if j != i {
                swap(&list[i], &list[j])
            }
        }
        return list
    }

    
    func save() {
        do{
            try managedObjectContext!.save()
        } catch {
            print(error)
        }
    }
    
    func getXNumberOfQuestionIds(numQuestions:Int) -> [String]
    {
        var questionIds:[String] = []
        for var i = 0 ; i < numQuestions ; i++
        {
            questionIds.append(String(historicEventItems[i].idForUpdate))
            //questionItems[i].
        }
        return questionIds
    }
    
    func fetchData(tags:[String] = [],fromLevel:Int,toLevel:Int) {
        
        // Create a new fetch request using the LogItem entity
        // eqvivalent to select * from Relation
        let fetchEvents = NSFetchRequest(entityName: "HistoricEvent")
        
        //let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        //fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        //let stringArray = tags.componentsSeparatedByString("#")
        var predicateTags:String = ""
        if tags.count > 0
        {
            for item in tags
            {
                if item != ""
                {
                    predicateTags = "\(predicateTags)|\(item)"
                }
            }
            predicateTags.removeAtIndex(predicateTags.startIndex)
        }
        //let predicate = NSPredicate(format: "titlenumber contains %@", "Worst")
        // Set the predicate on the fetch request
        //let predicate = NSPredicate(format: "periods.@count > 0 AND level >= \(fromLevel) AND level <= \(toLevel)")
        //let predicate = NSPredicate(format: "tags  MATCHES '.*(#war|#curiosa).*'")
        
        let predicate = NSPredicate(format: "level >= \(fromLevel) AND level <= \(toLevel) AND tags  MATCHES '.*(\(predicateTags)).*'")
        //let predicate = tags == "" ? NSPredicate(format: "periods.@count > 0 AND level >= \(fromLevel) AND level <= \(toLevel)") : NSPredicate(format: "ANY tags == \(tags)")
        fetchEvents.predicate = predicate
        
        fetchEvents.sortDescriptors = [NSSortDescriptor(key: "used", ascending: true)]
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchEvents)) as? [HistoricEvent] {
            historicEventItems = fetchResults
        }
        
        /*
        let fetchPeriods = NSFetchRequest(entityName: "Period")
        let sortDescriptor = NSSortDescriptor(key: "fromYear", ascending: true)
        fetchPeriods.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchPeriods, error: nil) as? [Period] {
          
            periodsItems = fetchResults
        }
        */
    }
    
    
    func fetchHistoricEventOnIds(ids:[String]) -> [HistoricEvent]?
    {
        
        let fetchEvents = NSFetchRequest(entityName: "HistoricEvent")

        //let predicate = NSPredicate(format: "titlenumber contains %@", "Worst")
        // Set the predicate on the fetch request
        //let predicate = NSPredicate(format: "periods.@count > 0 AND level >= \(fromLevel) AND level <= \(toLevel)")
        //let predicate = NSPredicate(format: "tags  MATCHES '.*(#war|#curiosa).*'")
        var predicateIds:String = "{"

        for item in ids
        {
            predicateIds = "\(predicateIds)\(item),"
        }
        
        predicateIds = String(predicateIds.characters.dropLast())
        predicateIds = "\(predicateIds)}"
        //predicateIds.removeAtIndex(predicateIds.startIndex)

        let predicate = NSPredicate(format: "idForUpdate IN \(predicateIds)") //NSPredicate(format: "idForUpdate IN \(predicateIds)")
        //let predicate = tags == "" ? NSPredicate(format: "periods.@count > 0 AND level >= \(fromLevel) AND level <= \(toLevel)") : NSPredicate(format: "ANY tags == \(tags)")
        fetchEvents.predicate = predicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchEvents)) as? [HistoricEvent] {
            return fetchResults
        }
        else
        {
            return nil
        }
    }
    
    func fetchQuestoinsForChallenge() -> [[String]]
    {
        var blocks:[[String]] = []
        var roundQuestionIds:[String] = []
        for var block = GlobalConstants.numOfQuestionsForRound; block >= 1 ; block--
        {
            var numberOfCardsInBlock = GlobalConstants.minNumDropZones
            if block > 2
            {
                numberOfCardsInBlock++
            }
            if block > 4
            {
                numberOfCardsInBlock++
            }
            if block > 6
            {
                numberOfCardsInBlock = GlobalConstants.maxNumDropZones
            }
            
            let randomHistoricEvents = getRandomHistoricEventsWithPrecision(25, numEvents:numberOfCardsInBlock)
            for item in randomHistoricEvents
            {
                roundQuestionIds.append("\(item.idForUpdate)")
            }
            blocks.append(roundQuestionIds)
            roundQuestionIds = []
        }

        return blocks
    }
    
    let DataPopulatedKey = "DataPopulated"
    let OkScoreKey = "OkScore"
    let GoodScoreKey = "GoodScore"
    let LoveScoreKey = "LoveScore"
    let TagsKey = "Tags"
    let LevelKey = "Level"
    let EventsUpdateKey = "EventsUpdate"
    let GameResultsKey = "GameResults"
    let AdFreeKey = "AdFree"
    
    var dataPopulatedValue:AnyObject = 0
    var okScoreValue:AnyObject = 0
    var goodScoreValue:AnyObject = 0
    var loveScoreValue:AnyObject = 0
    var tagsValue:AnyObject = 0
    var levelValue:AnyObject = 0
    var eventsUpdateValue:AnyObject = 0
    var adFreeValue:AnyObject = 0
    
    var gameResultsValues:[AnyObject] = []
    
    func loadGameData() {
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = (documentsDirectory as NSString).stringByAppendingPathComponent("GameData.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch _ {
                }
                print("copy")
            } else {
                print("GameData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("GameData.plist already exits at path. \(path)")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Loaded GameData.plist file is --> \(resultDictionary?.description)")
        let myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            //loading values
            dataPopulatedValue = dict.objectForKey(DataPopulatedKey)!
            okScoreValue = dict.objectForKey(OkScoreKey)!
            goodScoreValue = dict.objectForKey(GoodScoreKey)!
            loveScoreValue = dict.objectForKey(LoveScoreKey)!
            tagsValue = dict.objectForKey(TagsKey)!
            levelValue = dict.objectForKey(LevelKey)!
            eventsUpdateValue = dict.objectForKey(EventsUpdateKey)!
            adFreeValue = dict.objectForKey(AdFreeKey)!
            NSUserDefaults.standardUserDefaults().setBool(adFreeValue as! NSNumber == 1 ? true : false, forKey: "adFree")
            NSUserDefaults.standardUserDefaults().synchronize()
            gameResultsValues = dict.objectForKey(GameResultsKey)! as! [AnyObject]
        } else {
            print("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used!")
        }
    }
    
    func saveGameData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        //saving values
        dict.setObject(dataPopulatedValue, forKey: DataPopulatedKey)
        dict.setObject(okScoreValue, forKey: OkScoreKey)
        dict.setObject(goodScoreValue, forKey: GoodScoreKey)
        dict.setObject(loveScoreValue, forKey: LoveScoreKey)
        dict.setObject(tagsValue, forKey: TagsKey)
        dict.setObject(levelValue, forKey: LevelKey)
        dict.setObject(eventsUpdateValue, forKey: EventsUpdateKey)
        dict.setObject(adFreeValue, forKey: AdFreeKey)
        
        dict.setObject(gameResultsValues, forKey: GameResultsKey)
        //writing to GameData.plist
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved GameData.plist file is --> \(resultDictionary?.description)")
    }
    
    func getMaxTimeLimit(year: Double) -> Double
    {
        return year > todaysYear ? todaysYear : year
    }
}


