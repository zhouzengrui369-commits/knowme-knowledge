import agentContextPersistenceTest from './AgentContextPersistence.test';
import fixtureDemoTest from './FixtureDemo.test';
import fixtureTranscriptTest from './FixtureTranscript.test';
import voiceCoreTest from './VoiceCore.test';

export default function testsuite(): void {
  agentContextPersistenceTest();
  fixtureDemoTest();
  fixtureTranscriptTest();
  voiceCoreTest();
}
