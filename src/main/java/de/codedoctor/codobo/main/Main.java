package de.codedoctor.codobo.main;

import discord4j.core.DiscordClient;
import discord4j.core.DiscordClientBuilder;
import discord4j.core.event.domain.message.MessageCreateEvent;

public class Main {
    public static void main(String[] args) {
        System.out.println("Starting CoDoBo...");
        DiscordClient client = new DiscordClientBuilder(args[0]).build();
        client.getEventDispatcher().on(MessageCreateEvent.class) // This listens for all events that are of MessageCreateEvent
                .subscribe(event -> event.getMessage().getContent().ifPresent(System.out::println)); // "subscribe" is the method you need to call to actually make sure that it's doing something.
        client.login().block();
        System.out.println("Successfully started CoDoBo!");
    }
}
